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

    // Construir URL relativa con parámetros de ngx_small_light
    // Los parámetros se pasan como query string para ngx_small_light
    const baseUrl = `/img/image${imgNum}.jpg`;
    const params = new URLSearchParams();
    
    // Parámetros de ngx_small_light
    // small: formato "square,width" para imágenes cuadradas
    params.set("small", `square,${size}`);
    
    // Borde exterior
    params.set("small:extborder", border);
    params.set("small:extbordercolor", borderColor);
    
    // Enfoque y desenfoque
    params.set("small:radialblur", focus);
    params.set("small:gaussianblur", blur);

    img.src = `${baseUrl}?${params.toString()}`;
    img.alt = `Imagen ${imgNum}`;
    img.title = `Imagen ${imgNum}`;

    gallery.appendChild(img);
  }
});

// Generar imágenes al cargar la página
document.getElementById("imageForm").dispatchEvent(new Event("submit"));

