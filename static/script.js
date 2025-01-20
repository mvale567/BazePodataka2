document.addEventListener("DOMContentLoaded", function () {
  // Funkcija za upravljanje dropdown-om
  function aktiviraj_dropdown(buttonId) {
    const btn = document.getElementById(buttonId);
    const dropdown = btn.nextElementSibling;

    btn.addEventListener("click", function (e) {
      e.preventDefault();
      btn.classList.toggle("active"); // Dodaj ili ukloni klasu za rotaciju strelice
      dropdown.style.display =
        dropdown.style.display === "block" ? "none" : "block";
    });

    // Klik na bilo gdje van dropdown-a da ga zatvori
    document.addEventListener("click", function (e) {
      if (!btn.contains(e.target)) {
        btn.classList.remove("active");
        dropdown.style.display = "none";
      }
    });
  }

  // Pozivanje funkcije za dropdown izbornike
  aktiviraj_dropdown("zahtjeviBtn"); // Za zahtjeve
  aktiviraj_dropdown("skladistaBtn"); // Za skladišta
  aktiviraj_dropdown("racunovodstvoBtn"); // Za racunovodstvo
});


// linkanje preko gumbova sa data-url=''
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".tablica_nav-button").forEach((button) => {
    button.addEventListener("click", function () {
      const url = this.getAttribute("data-url");
      window.location.href = url;
    });
  });
});
