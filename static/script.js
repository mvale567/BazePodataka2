document.addEventListener('DOMContentLoaded', function () {
    const zahtjeviBtn = document.getElementById('zahtjeviBtn');
    const dropdown = zahtjeviBtn.nextElementSibling;

    zahtjeviBtn.addEventListener('click', function (e) {
        e.preventDefault();
        zahtjeviBtn.classList.toggle('active'); // Dodaj ili ukloni klasu za rotaciju strelice
        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
    });

    // Klik na bilo gdje van dropdown-a da ga zatvori
    document.addEventListener('click', function (e) {
        if (!zahtjeviBtn.contains(e.target)) {
            zahtjeviBtn.classList.remove('active');
            dropdown.style.display = 'none';
        }
    });
});


// zaposlenik sortiranje, dropdown
document.addEventListener('DOMContentLoaded', function () {
    const sortBtn = document.getElementById("sortBtn");
    const dropdown = document.querySelector(".dropdown");

    sortBtn.addEventListener("click", () => {
        // Toggle klasu 'active' za dropdown
        dropdown.classList.toggle("active");
    });
});