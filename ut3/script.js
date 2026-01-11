document.getElementById("imageForm").addEventListener("submit", function (e) {
  e.preventDefault();

  const size = document.getElementById("size").value;
  const border = document.getElementById("border").value;
  const borderColor = document.getElementById("borderColor").value;
  const focus = document.getElementById("focus").value;
  const blur = document.getElementById("blur").value;

  const gallery = document.getElementById("gallery");
  gallery.innerHTML = "";

  // Generar las 20 imágenes con los parámetros
  for (let i = 1; i <= 20; i++) {
    const imgNum = i.toString().padStart(2, "0");
    const img = document.createElement("img");

    // Construir URL con parámetros de ngx_small_light
    const baseUrl = `https://images.toninavhd.me/img/image${imgNum}.jpg`;
    const params = new URLSearchParams({
      small: `square,${size}`,
      "small:extborder": border,
      "small:extbordercolor": borderColor,
      "small:radialblur": focus,
      "small:gaussianblur": blur,
    });

    img.src = `${baseUrl}?${params.toString()}`;
    img.alt = `Imagen ${imgNum}`;
    img.title = `Imagen ${imgNum}`;

    gallery.appendChild(img);
  }
});

// Generar imágenes al cargar la página
document.getElementById("imageForm").dispatchEvent(new Event("submit"));
