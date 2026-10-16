
const fs=require('fs'),crypto=require('crypto'),assert=require('assert/strict');
const cfg=JSON.parse(fs.readFileSync('android/app/google-services.json','utf8'));
const apiKey=cfg.client[0].api_key[0].current_key;
const project=cfg.project_info.project_id;
const base='https://firestore.googleapis.com/v1/projects/'+project+'/databases/(default)/documents';
const users=[],paths=[];let passes=0;
function value(v){
 if(v instanceof Date)return {timestampValue:v.toISOString()};
 if(v===null)return {nullValue:null};
 if(Array.isArray(v))return {arrayValue:{values:v.map(value)}};
 if(typeof v==='object')return {mapValue:{fields:fields(v)}};
 if(typeof v==='number')return {integerValue:String(v)};
 if(typeof v==='boolean')return {booleanValue:v};
 return {stringValue:v};
}
function fields(o){return Object.fromEntries(Object.entries(o).map(([k,v])=>[k,value(v)]));}
async function http(url,method,body,token){
 const r=await fetch(url,{method,headers:{'Content-Type':'application/json',...(token?{Authorization:'Bearer '+token}:{})},...(body?{body:JSON.stringify(body)}:{})});
 const data=await r.json().catch(()=>({}));return {status:r.status,data};
}
async function signup(anonymous=false){
 const body={returnSecureToken:true};
 if(!anonymous){body.email='chorejar-test-'+crypto.randomBytes(8).toString('hex')+'@example.invalid';body.password=crypto.randomBytes(24).toString('hex');}
 const r=await http('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key='+apiKey,'POST',body);
 assert.equal(r.status,200,'Test account signup failed: '+(r.data.error?.message??r.status));
 users.push(r.data);return r.data;
}
async function put(path,data,user){return http(base+'/'+path,'PATCH',{fields:fields(data)},user.idToken);}
async function get(path,user){return http(base+'/'+path,'GET',null,user?.idToken);}
function ok(label,r,status=200){assert.equal(r.status,status,label+': '+JSON.stringify(r.data.error??{}));console.log('PASS '+label);passes++;}
function child(id){return{id,name:'Test child',currency:'USD',accessVersion:0,avatar:'star',mode:'both',goalName:'Bike',goalAmount:10000,allowanceAmount:0,allowanceFrequency:'weekly',allowanceNext:'',allowancePlan:'',archived:false,tasks:{task1:{id:'task1',title:'Test task',instructions:'Test',frequency:'once',due:'2026-10-07',status:'pending',feedback:'',amount:200}},entries:{}};}
(async()=>{
 let parent;
 try{
  parent=await signup();const stranger=await signup(),kid=await signup(true);
  const owner=parent.localId,root='families/'+owner,a=root+'/children/a',b=root+'/children/b';
  paths.push(root,a,b);
  ok('parent creates family',await put(root,{currency:'USD',country:'US',created:new Date()},parent));
  ok('parent creates first child',await put(a,child('a'),parent));
  ok('parent creates sibling',await put(b,child('b'),parent));
  const second=await signup(),third=await signup();
  const pcode=crypto.randomBytes(16).toString('hex'),pcode2=crypto.randomBytes(16).toString('hex');
  const pinvite='parentInvites/'+pcode,pinvite2='parentInvites/'+pcode2;
  const member='parentMembers/'+owner,plink='parentLinks/'+second.localId;
  paths.push(pinvite,pinvite2);
  const pi={owner,claimedBy:'',expires:new Date(Date.now()+600000)};
  ok('owner invites second parent',await put(pinvite,pi,parent));
  ok('owner creates alternate pending invitation',await put(pinvite2,pi,parent));
  ok('anonymous cannot read parent invitation',await get(pinvite,kid),403);
  ok('stranger cannot grant own membership',await put(member,{uid:second.localId,invite:pcode},second),403);
  const docName=path=>'projects/'+project+'/databases/(default)/documents/'+path;
  const join=async(user,code)=>http(base+':commit','POST',{writes:[
   {update:{name:docName(member),fields:fields({uid:user.localId,invite:code})}},
   {update:{name:docName('parentLinks/'+user.localId),fields:fields({owner,invite:code})}},
   {update:{name:docName('parentInvites/'+code),fields:fields({claimedBy:user.localId})},updateMask:{fieldPaths:['claimedBy']}}
  ]},user.idToken);
  ok('anonymous cannot become parent',await join(kid,pcode),403);
  ok('second parent joins atomically',await join(second,pcode));
  ok('second parent resumes via own link',await get(plink,second));
  ok('second parent reads shared family',await get(root,second));
  ok('second parent reads child',await get(a,second));
  const edited=child('a');edited.name='Shared edit';
  ok('second parent edits child',await put(a,edited,second));
  const shared=await get(a,parent);ok('owner sees second parent edit',shared);
  assert.equal(shared.data.fields.name.stringValue,'Shared edit');
  ok('third parent blocked even with valid code',await join(third,pcode2),403);
  ok('second parent cannot delete family',await http(base+'/'+root,'DELETE',null,second.idToken),403);
  ok('second parent cannot create own family',await put('families/'+second.localId,{currency:'USD',country:'US',created:new Date()},second),403);
  ok('owner cannot leave orphan membership',await http(base+'/'+member,'DELETE',null,parent.idToken),403);
  const remove=async(user)=>http(base+':commit','POST',{writes:[{delete:docName(member)},{delete:docName(plink)}]},user.idToken);
  ok('owner removes second parent atomically',await remove(parent));
  ok('revoked parent cannot read child',await get(a,second),403);
  ok('revoked parent cannot write child',await put(a,edited,second),403);
  ok('claimed code cannot be reused',await join(second,pcode),403);
  ok('second parent can rejoin with unused code',await join(second,pcode2));
  ok('second parent can leave without deleting family',await remove(second));
  ok('family survives second parent leaving',await get(a,parent));
  ok('unauthenticated read denied',await get(a),403);
  ok('other family read denied',await get(a,stranger),403);
  ok('unlinked child denied',await get(a,kid),403);
  const code=crypto.randomBytes(16).toString('hex'),invite='invites/'+code,link='links/'+kid.localId;
  paths.push(invite,link);
  const inv={owner,childId:'a',claimedBy:'',accessVersion:0,expires:new Date(Date.now()+600000)};
  ok('parent creates single-use invitation',await put(invite,inv,parent));
  const commit=await http(base+':commit','POST',{writes:[
   {update:{name:'projects/'+project+'/databases/(default)/documents/'+link,fields:fields({owner,childId:'a',invite:code,accessVersion:0})}},
   {update:{name:'projects/'+project+'/databases/(default)/documents/'+invite,fields:fields({claimedBy:kid.localId})},updateMask:{fieldPaths:['claimedBy']}}
  ]},kid.idToken);
  ok('child claims invitation atomically',commit);
  ok('linked child reads own profile',await get(a,kid));
  ok('linked child cannot read sibling',await get(b,kid),403);
  const newGoal=child('a');newGoal.name='Shared edit';newGoal.goalName='My tablet';newGoal.goalImage='tablet';newGoal.goalAmount=25000;
  ok('linked child chooses own goal',await put(a,newGoal,kid));
  ok('parent sees child goal',await get(a,parent));
  for (const image of ['sneakers','backpack','soccer','camera','guitar','robot','blocks','scooter','watch','artkit']) {
   newGoal.goalImage=image;
   ok('child can choose '+image,await put(a,newGoal,kid));
  }
  const badGoal=structuredClone(newGoal);badGoal.entries.fake={amount:900};
  ok('goal choice cannot change money',await put(a,badGoal,kid),403);
  const siblingGoal=child('b');siblingGoal.goalName='Wrong profile';siblingGoal.goalImage='teddy';
  ok('child cannot change sibling goal',await put(b,siblingGoal,kid),403);
  const invalidGoal=structuredClone(newGoal);invalidGoal.goalImage='unknown';
  ok('child cannot store arbitrary asset',await put(a,invalidGoal,kid),403);
  const submitted=structuredClone(newGoal);submitted.tasks.task1.status='review';submitted.lastSubmitted='task1';
  ok('child sends task for review',await put(a,submitted,kid));
  const malicious=structuredClone(submitted);malicious.tasks.task1.amount=999999;
  ok('child cannot change reward',await put(a,malicious,kid),403);
  const approved=structuredClone(submitted);approved.tasks.task1.status='approved';
  ok('child cannot approve',await put(a,approved,kid),403);
  approved.entries.credit={id:'credit',kind:'reward',date:new Date().toISOString(),amount:200,delta:[200,0,0,0,0],note:'test',reference:'task1',allocations:{}};
  ok('parent approves and records reward',await put(a,approved,parent));
  const synced=await get(a,kid);ok('second session sees approval',synced);
  assert.equal(synced.data.fields.tasks.mapValue.fields.task1.mapValue.fields.status.stringValue,'approved');
  const rewritten=structuredClone(approved);rewritten.entries.credit.amount=300;
  ok('existing ledger entries cannot be rewritten',await put(a,rewritten,parent),403);
  ok('child cannot alter ledger',await put(a,rewritten,kid),403);
  const revoked=structuredClone(approved);revoked.accessVersion=1;
  ok('parent increments access version',await put(a,revoked,parent));
  ok('version change blocks child before link cleanup',await get(a,kid),403);
  ok('parent revokes link',await http(base+'/'+link,'DELETE',null,parent.idToken));
  paths.splice(paths.indexOf(link),1);
  ok('revoked child denied',await get(a,kid),403);
  console.log(passes+' cloud checks passed.');
 }finally{
  if(parent){
   const slotPath='parentMembers/'+parent.localId;
   const slot=await get(slotPath,parent);
   if(slot.status===200){
    const prefix='projects/'+project+'/databases/(default)/documents/';
    const clean=await http(base+':commit','POST',{writes:[
     {delete:prefix+slotPath},
     {delete:prefix+'parentLinks/'+slot.data.fields.uid.stringValue}
    ]},parent.idToken);
    if(clean.status!==200)console.error('Cleanup membership failed: '+clean.status);
   }
   for(const path of paths.reverse()){
   const r=await http(base+'/'+path,'DELETE',null,parent.idToken);
   if(![200,404].includes(r.status))console.error('Cleanup document failed: '+r.status);
  }}
  for(const user of users){
   const r=await http('https://identitytoolkit.googleapis.com/v1/accounts:delete?key='+apiKey,'POST',{idToken:user.idToken});
   if(r.status!==200)console.error('Cleanup test account failed: '+r.status);
  }
  console.log('Temporary test accounts and documents cleanup completed.');
 }
})().catch(e=>{console.error(e.message);process.exitCode=1;});
