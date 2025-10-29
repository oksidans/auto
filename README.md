# auto

#Sistem za Zakazivanje Servisnih Termina

Uvod
Ovaj projekat predstavlja veb aplikaciju razvijenu u MVC arhitekturi koristeći Objektno-Orijentisani PHP (OO PHP) i Twig templating engine. Cilj aplikacije je efikasno upravljanje procesom slanja upita za servis i zakazivanjem termina, simulirajući rad servisa sa različitim ulogama korisnika.

Baza Podataka i Struktura
Aplikacija koristi Relacionu bazu podataka (MySQL sa InnoDB engine-om) sa implementiranim stranim ključevima radi održavanja integriteta podataka.

Šema Tabela
users: Evidencija korisnika i njihovih uloga (user, manager, admin).

mechanics: Podaci o dostupnim majstorima.

customers: Podaci o klijentima.

vehicles: Evidencija vozila vezanih za servis.

appointments: Tabela za zvanično zakazane termine.

inquiries: Tabela za pristigle upite za termin.

activity_log: Tabela za beleženje ključnih sistemskih aktivnosti (za potencijalni DB-audit).

Pogledi
v_daily_capacity: Pogled baze podataka koji služi za efikasan proračun i prikaz dnevne zauzetosti (slotova) po majstorima.

Arhitektura i Tehnologije
Projekat je striktno strukturiran na principima MVC obrasca:

Arhitektura: Model-View-Controller (MVC).

Jezik: Objektno-Orijentisani PHP (OO PHP).

Templating: Twig, za jasno razdvajanje prezentacije od poslovne logike.

Zavisnosti: Composer za upravljanje bibliotekama.

Organizacija Koda: Standardna klasna organizacija (Controllers, Services, Models, Routes, Middlewares, Views).

Konfiguracija i Logovanje: Konfiguracioni fajlovi smešteni su u config/, a sistemski logovi u storage/logs/.

Funkcionalnosti (Po Ulogama)
Gost (Neregistrovani korisnik)
Dnevna Dostupnost: Prikaz dnevne raspoloživosti majstora (broj zauzetih / slobodnih slotova).

Poziv na Akciju: Ako korisnik nije ulogovan, vidi se tabelarni pregled dostupnosti uz poziv na registraciju ili prijavu.

Registrovani Korisnik (Uloga: user)
Slanje Upita: Nakon prijave, pristup formi za slanje novog upita (inquiry).

Detalja Upita: Mogućnost izbora željenog majstora i dodavanje beleške.

Potvrda: Po uspešnom slanju upita, prikazuje se poruka o uspehu, a forma se uklanja (sprečavanje duplog unosa).

Menadžer (Uloga: manager)
Pregled Upita: Pristup stranici /manager/inquiries sa pregledom svih pristiglih upita.

Konverzija Upita: Mogućnost konvertovanja upita u zvaničan termin (appointment), uz izbor datuma i slota (Slot 1 ili Slot 2).

Planirano: Pregled liste korisnika i zatvaranje servisnih slučajeva.

Administrator (Uloga: admin)
Izveštaji: Pristup administrativnoj stranici /admin/reports.

Eksport Podataka:

Upiti (inquiries): Eksport u formatima PDF ili XLSX (npr. /admin/reports/inquiries?format=pdf).

Termini (appointments): Eksport u formatima PDF ili XLSX.

Sigurnost i Evidencija
Hashiranje Lozinki: Lozinke se čuvaju isključivo kao bcrypt hashevi (password_hash()).

CSRF Zaštita: Implementacija CSRF tokena u svim formama za slanje podataka.

Sesije: Konfiguracija sesija sa httponly i samesite=Lax atributima.

Evidencija Aktivnosti (activity_log): Logovanje ključnih sistemskih akcija (prijava/odjava, slanje upita, konverzija, eksporti) u log fajl.
