(function () {
  var lightbox = null;
  var lightboxImage = null;
  var closeButton = null;
  var previousFocus = null;
  var emptyImage = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1 1'%3E%3C/svg%3E";

  function getLargeImageUrl(image) {
    var source = image.currentSrc || image.src;
    if (!source) {
      return "";
    }
    return source.replace(/-(480|960|1440)(\.jpe?g)$/i, "$2");
  }

  function closeLightbox() {
    if (!lightbox || lightbox.hidden) {
      return;
    }
    lightbox.hidden = true;
    document.body.classList.remove("lightbox-open");
    lightboxImage.src = emptyImage;
    lightboxImage.removeAttribute("alt");
    if (previousFocus && typeof previousFocus.focus === "function") {
      previousFocus.focus();
    }
  }

  function openLightbox(image) {
    if (!lightbox || !lightboxImage) {
      return;
    }
    previousFocus = document.activeElement;
    lightboxImage.src = getLargeImageUrl(image);
    lightboxImage.alt = image.alt || "Expanded home photo";
    lightbox.hidden = false;
    document.body.classList.add("lightbox-open");
    closeButton.focus();
  }

  function buildLightbox() {
    lightbox = document.createElement("div");
    lightbox.className = "image-lightbox";
    lightbox.hidden = true;
    lightbox.setAttribute("role", "dialog");
    lightbox.setAttribute("aria-modal", "true");
    lightbox.setAttribute("aria-label", "Expanded image preview");
    lightbox.innerHTML = '<button class="image-lightbox-close" type="button" aria-label="Close expanded image">&times;</button><div class="image-lightbox-frame"><img alt=""></div>';
    document.body.appendChild(lightbox);
    closeButton = lightbox.querySelector(".image-lightbox-close");
    lightboxImage = lightbox.querySelector("img");
    lightboxImage.src = emptyImage;

    closeButton.addEventListener("click", closeLightbox);
    lightbox.addEventListener("click", function (event) {
      if (event.target === lightbox) {
        closeLightbox();
      }
    });
    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        closeLightbox();
      }
    });
  }

  function enhanceImages() {
    var images = document.querySelectorAll("main picture img");
    images.forEach(function (image) {
      image.classList.add("js-lightbox-image");
      image.setAttribute("tabindex", "0");
      image.setAttribute("role", "button");
      image.setAttribute("aria-label", "Open image fullscreen: " + (image.alt || "home photo"));
      image.addEventListener("click", function () {
        openLightbox(image);
      });
      image.addEventListener("keydown", function (event) {
        if (event.key === "Enter" || event.key === " ") {
          event.preventDefault();
          openLightbox(image);
        }
      });
    });
  }

  function enhanceMailtoForms() {
    var forms = document.querySelectorAll("[data-mailto-form]");
    forms.forEach(function (form) {
      form.addEventListener("submit", function (event) {
        event.preventDefault();
        var to = form.getAttribute("data-mailto-to") || "";
        var data = new FormData(form);
        var lines = [];
        data.forEach(function (value, key) {
          if (value) {
            lines.push(key + ": " + value);
          }
        });
        var subject = encodeURIComponent("Contact request from Life Worth Living website");
        var body = encodeURIComponent(lines.join("\n"));
        window.location.href = "mailto:" + to + "?subject=" + subject + "&body=" + body;
      });
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    buildLightbox();
    enhanceImages();
    enhanceMailtoForms();
  });
})();
