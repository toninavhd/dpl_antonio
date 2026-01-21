document.getElementById("imageForm").addEventListener("submit", function (e) {
  e.preventDefault();

  const size = document.getElementById("size").value;
  const border = document.getElementById("border").value;
  const borderColor = document.getElementById("borderColor").value;
  const focus = document.getElementById("focus").value;
  const blur = document.getElementById("blur").value;

  const gallery = document.getElementById("gallery");
  gallery.innerHTML = "";

  // Generar las 20 imágenes con los parámetros usando ngx_small_light
  for (let i = 1; i <= 20; i++) {
    const imgNum = i.toString().padStart(2, "0");
    const img = document.createElement("img");

    // Construir URL relativa con parámetros GET de ngx_small_light
    // IMPORTANTE: ngx_small_light usa parámetros directos: dw, dh, bw, bc, blur, sharpen
    const baseUrl = `/img/image${imgNum}.jpg`;
    const params = new URLSearchParams();
    
    // Parámetros de ngx_small_light (formato GET directo)
    // dw = destination width, dh = destination height
    // da = l (long-edge based) para mantener aspecto cuadrado
    params.set("dw", size);
    params.set("dh", size);
    params.set("da", "l");
    
    // Borde (bw = border width, bc = border color)
    if (border > 0) {
      params.set("bw", border);
      // Eliminar # del color hexadecimal
      params.set("bc", borderColor.replace("#", ""));
    }
    
    // Enfoque (sharpen: radius x sigma)
    if (focus && focus !== "0x0") {
      params.set("sharpen", focus);
    }
    
    // Desenfoque (blur: radius x sigma)
    if (blur && blur !== "0x0") {
      params.set("blur", blur);
    }

    img.src = `${baseUrl}?${params.toString()}`;
    img.alt = `Imagen ${imgNum}`;
    img.title = `Imagen ${imgNum}`;

    gallery.appendChild(img);
  }
});

// Generar imágenes al cargar la página
document.getElementById("imageForm").dispatchEvent(new Event("submit"));
