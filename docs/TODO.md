# TODO

## 1. Przygotowanie środowiska projektu
- [x] Utworzenie struktury katalogów:
  - `/src` - kod źródłowy,
  - `/data` - pliki danych wejściowych/wyjściowych,
  - `/docs` - dokumentacja,
  - `/results` - wyniki symulacji.

---

## 2. Modelowanie trajektorii obiektów
- [x] Zdefiniowanie przestrzeni symulacyjnej:
  - Parametry obszaru (np. 200x200 km).
  - Stałe modelowe (próg detekcji, zakres szumów itp.).
- [x] Stworzenie funkcji generującej trajektorie:
  - `generateTrajectory.m`: generuje trajektorie obiektów w przestrzeni.
  - Uwzględnienie różnych typów ruchu (np. jednostajny, zmienny).
- [x] Implementacja losowego generowania pozycji i prędkości obiektów:
  - Funkcja losująca prędkości i kierunki.
  - Funkcja losująca RCS dla fałszywych obiektów (rozkład Rayleigha).
  - Funkcja losująca RCS dla prawdziwych obiektów (na podstawie Pfa).
- [x] Dodanie symulacji fałszywych trajektorii wynikających z szumów.

---

## 3. Symulacja działania radaru
- [x] Stworzenie modelu symulacyjnego radaru:
  - `simulateRadar.m`: symuluje działanie radaru, generuje wykrycia.
- [x] Implementacja progu detekcji:
  - Uwzględnienie szumu na podstawie rozkładu Rayleigha.
  - Funkcja określająca, czy punkt jest wykryty (np. `isDetected.m`).
- [x] Dodanie funkcjonalności symulacji błędów pomiarowych:
  - Szum procesowy i pomiarowy (parametryzowany sigma).

---

## 4. Analiza trajektorii i filtrowanie
- [ ] Stworzenie funkcji analizy trajektorii:
  - `mahalonobisTrajectories.m`: sprawdza, czy punkty należą do jednej trajektorii.
  - Wykorzystanie odległości Mahalanobisa do obliczeń wiarygodności.
  - Połączenie punktów w trajektorie (metoda 3 z 5).
- [ ] Dodanie wizualizacji trajektorii:
  - Wyświetlenie wykryć na wykresie (prawdziwe i fałszywe trajektorie różnymi kolorami).

---

## 5. Generowanie danych do trenowania sieci neuronowej
- [ ] Utworzenie zbioru danych:
  - Generowanie trajektorii prawdziwych i fałszywych w różnych warunkach (różne poziomy szumów, różne progi detekcji).
  - Zapis danych do plików w formacie kompatybilnym z MATLAB-em (np. `.mat`).
- [ ] Oznaczenie danych:
  - Oznaczenie danych jako prawdziwe lub fałszywe na podstawie wyników symulacji.
- [ ] Przygotowanie funkcji eksportującej dane:
  - `exportData.m`: zapisuje trajektorie i metadane do plików.

---

## 6. Implementacja sieci neuronowej
- [ ] Import toolboxa do uczenia maszynowego.
- [ ] Stworzenie i trenowanie sieci:
  - Funkcja `trainNeuralNet.m` do trenowania sieci na wygenerowanych danych.
  - Testowanie różnych konfiguracji sieci (np. liczba warstw, neurony, funkcje aktywacji).
- [ ] Implementacja funkcji walidacji:
  - `validateModel.m`: ocenia skuteczność sieci na zbiorze testowym.

---

## 7. Walidacja wyników
- [ ] Przeprowadzenie testów symulacyjnych:
  - Weryfikacja poprawności trajektorii na różnych poziomach szumu i progów detekcji.
- [ ] Analiza skuteczności algorytmu detekcji:
  - Obliczenie wskaźników dokładności (precision, recall itp.).
- [ ] Wizualizacja wyników:
  - Tworzenie wykresów porównawczych dla różnych scenariuszy.

---

## 8. Dokumentacja i przygotowanie wyników
- [ ] Udokumentowanie kodu:
  - Dodanie komentarzy do wszystkich funkcji.
- [ ] Przygotowanie raportu z wynikami:
  - Opis wyników symulacji, wnioski oraz skuteczność sieci neuronowej.
- [ ] Przygotowanie prezentacji projektu:
  - Slajdy z wynikami i procesem implementacji.

---

## 9. Iteracyjne poprawki
- [ ] Poprawa błędów znalezionych podczas testów.
- [ ] Optymalizacja kodu pod kątem wydajności.
- [ ] Konsultacje z promotorem i wdrażanie jego uwag.
