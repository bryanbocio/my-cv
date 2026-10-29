# my-cv

CV de una sola página (A4) en HTML, bilingüe ES/EN.

- `index.html` — el CV completo (estilos y JS incluidos). Acepta `?lang=en` para abrirlo en inglés.
- `pdf/` — PDFs descargables que sirve el botón **Descargar PDF**. Los genera CI, no los edites a mano.
- `scripts/build-pdf.ps1` — los regenera en local con Chrome headless (para previsualizar).
- `.github/workflows/build-pdf.yml` — los regenera y commitea en cada push a `main`.

## Cómo se mantiene el PDF al día

El botón de descarga sirve archivos pregenerados, así que tienen que reconstruirse cada vez que
cambia el CV. De eso se encarga el workflow: editas `index.html`, haces push a `main`, y la Action
vuelve a renderizar ambos PDFs, comprueba que cada uno tenga exactamente una página y esté en el
idioma correcto, y los commitea si cambiaron.

Para previsualizar en local antes de hacer push:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build-pdf.ps1
```

**Deja que CI tenga la última palabra sobre `pdf/`.** El render local usa Segoe UI (Windows) y el de
CI usa Liberation Sans (métricamente igual a Arial, que es el siguiente en la cadena de fuentes),
así que los dos no son idénticos al pixel. Si commiteas un PDF hecho en local, el siguiente push lo
sobrescribe.

Ambos caminos usan el mismo motor de render y el mismo CSS `@media print` que la página, de modo
que el texto del PDF queda vectorial y seleccionable (legible por los filtros ATS).
