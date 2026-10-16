const fs=require('node:fs'),path=require('node:path'),sharp=require('sharp');
const root=path.resolve(__dirname,'..');
(async()=>{
 const source=process.argv[2]; if(!source) throw Error('Pass source PNG');
 const original=path.join(root,'design/source-images/chorejar-icon-v2.png');
 await sharp(source).resize(1024,1024).flatten({background:'#fffaf0'}).removeAlpha().png().toFile(original);
 const icons=path.join(root,'ios/Runner/Assets.xcassets/AppIcon.appiconset');
 const manifest=JSON.parse(fs.readFileSync(path.join(icons,'Contents.json')));
 for(const item of manifest.images){
   const size=Math.round(parseFloat(item.size)*parseFloat(item.scale));
   item.filename='chorejar-v2-'+size+'.png';
   await sharp(original).resize(size,size).png().toFile(path.join(icons,item.filename));
 }
 fs.writeFileSync(path.join(icons,'Contents.json'),JSON.stringify(manifest,null,2)+'\n');
 for(const [density,size] of Object.entries({mdpi:48,hdpi:72,xhdpi:96,xxhdpi:144,xxxhdpi:192})){
   await sharp(original).resize(size,size).png().toFile(path.join(root,'android/app/src/main/res/mipmap-'+density+'/chorejar_icon_v2.png'));
 }
 await sharp(original).resize(256,256).webp({quality:82,effort:6}).toFile(path.join(root,'assets/library/chorejar-icon-v2.webp'));
 await sharp(original).resize(64,64).png().toFile(path.join(root,'web/favicon.png'));
 fs.copyFileSync(original,'/Users/juanpolanco/Documents/Codex/2026-10-07/chore/outputs/chorejar-icon-v2.png');
 console.log(await sharp(original).metadata());
})();
