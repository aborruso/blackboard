# Fix npm vulnerabilities (12 total: 2 high, 8 moderate, 2 low)

## Completate
- socket.io: risolte CVE-2020-28481, CVE-2024-38355

# Rimanenti - reveal.js dependencies

## Problema
socket.io ~1.3.7 in reveal.js ha 4 CVE (CVE-2020-28481, CVE-2024-38355)

## File affetti
- `presentazioni/civicTechNapoli2016/reveal.js/package.json`
- `presentazioni/civicTechNapoli2016/reveal.js/plugin/multiplex/package.json`

## Tasks
- [x] Aggiorna socket.io da ~1.3.7 a ~2.4.0 in reveal.js/package.json
- [x] Aggiorna socket.io da ~1.3.7 a ~2.4.0 in plugin/multiplex/package.json
- [x] Verifica se serve aggiornare altre dipendenze (express, ecc.)

## Review
Aggiornato socket.io a ~2.4.0 in entrambi i package.json. Risolve CVE-2020-28481 e CVE-2024-38355.

Express ~4.13.3 è vecchio ma GitHub alert è solo per socket.io. Se necessario, si può aggiornare in seguito.

## Note
reveal.js è usato solo per presentazioni statiche su GitHub Pages. Socket.io è per multiplex (controllo remoto presentazioni), probabilmente non attivo in produzione.
