const http = require('http');
const { exec } = require('child_process');

const server = http.createServer((req, res) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Content-Type', 'application/json');

    const action = req.url.split('/')[2];
    let command = '';

    console.log(`[REQUEST] Action: ${action}`);

    switch (action) {
        case 'resilience':
            command = 'kubectl delete pods -l app=backend';
            break;
        case 'traffic':
            // Commande PowerShell pour générer 20 requêtes rapides sur Windows
            command = 'powershell -Command "for($i=0; $i -lt 20; $i++) { iwr -Uri http://127.0.0.1:65029/ -UseBasicParsing | Out-Null }"';
            break;
        case 'gitops':
            command = 'git commit -am "PRO-DEMO: Web Triggered Sync" --allow-empty && git push origin main';
            break;
        default:
            return res.end(JSON.stringify({ error: 'Inconnu' }));
    }

    exec(command, (error, stdout, stderr) => {
        // Sur Windows, stderr contient souvent des infos non-critiques (git, kubectl)
        // On considère une erreur UNIQUEMENT si le code de sortie n'est pas 0 (error object existe)
        const output = stdout + "\n" + stderr;
        console.log(`[EXEC DONE] Output length: ${output.length}`);

        res.end(JSON.stringify({
            status: error ? 'error' : 'success',
            cmd: command,
            output: output.trim() || 'Exécution réussie (pas de retour texte).'
        }));
    });
});

server.listen(5000, () => {
    console.log('=========================================');
    console.log('🚀 BRIDGE DEVOPS v2.0 - CONNECTÉ');
    console.log('Prêt pour les commandes Windows natives');
    console.log('=========================================');
});
