import http from 'node:http';
import {readFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
const files = {'/':'index.html','/index.html':'index.html','/practice.js':'practice.js','/app.js':'app.js','/style.css':'style.css'};
http.createServer(async(req,res)=>{
 const file=files[new URL(req.url,'http://localhost').pathname];
 if(!file){res.writeHead(404);return res.end('Not found');}
 try {const data=await readFile(fileURLToPath(new URL(file,import.meta.url)));res.writeHead(200,{'Content-Type':file.endsWith('.css')?'text/css':file.endsWith('.js')?'text/javascript':'text/html; charset=utf-8'});res.end(data);} catch {res.writeHead(500);res.end('Unable to load page');}
}).listen(4174,'127.0.0.1',()=>console.log('Local: http://127.0.0.1:4174'));
