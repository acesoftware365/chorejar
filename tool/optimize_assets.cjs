// Run with Node and sharp available through NODE_PATH.
const fs = require('node:fs');
const path = require('node:path');
const sharp = require('sharp');
const root = path.resolve(__dirname, '..');
const specs = [
 ['money-jar', 'child', 768], ['piggy-bank', 'child', 384],
 ['bicycle', 'child', 384], ['iphone', 'child', 384],
 ['console', 'child', 384], ['headphones', 'child', 384],
 ['chorejar-icon-v2', 'brand', 256],
 ['sneakers', 'child', 384],
 ['backpack', 'child', 384],
 ['soccer', 'child', 384],
 ['camera', 'child', 384],
 ['guitar', 'child', 384],
 ['robot', 'child', 384],
 ['blocks', 'child', 384],
 ['scooter', 'child', 384],
 ['watch', 'child', 384],
 ['artkit', 'child', 384],

 ['teddy', 'child', 384], ['skateboard', 'child', 384], ['tablet', 'child', 384],
];
(async () => {
 const dest=path.join(root,'assets/library');
 fs.mkdirSync(dest,{recursive:true});
 const report=[];
 for (const [id,folder,edge] of specs) {
   const archived=path.join(root,'design/source-images',id+'.png');
   const original=path.join(root,'assets',folder,id+'.png');
   const source=fs.existsSync(archived) ? archived : original;
   const output=path.join(dest,id+'.webp');
   await sharp(source).resize(edge,edge,{fit:'inside',withoutEnlargement:true})
     .webp({quality:82,alphaQuality:95,effort:6}).toFile(output);
   const meta=await sharp(output).metadata();
   report.push({id,width:meta.width,height:meta.height,alpha:meta.hasAlpha,
     before:fs.statSync(source).size,after:fs.statSync(output).size});
 }
 fs.writeFileSync(path.join(root,'design/asset-sizes.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify({assets:report,before:report.reduce((s,v)=>s+v.before,0),after:report.reduce((s,v)=>s+v.after,0)},null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
