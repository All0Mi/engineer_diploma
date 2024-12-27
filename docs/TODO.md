# TODO

## 1. Przygotowanie środowiska projektu
- [x] Utworzyć strukturę katalogów:
  - `/src` - kod źródłowy,
  - `/data` - pliki danych wejściowych/wyjściowych,
  - `/docs` - dokumentacja,
  - `/results` - wyniki symulacji.

---

## 2. Modelowanie trajektorii obiektów
- [x] Zdefiniować przestrzeń symulacyjną:
  - Parametry obszaru (np. 200x200 km).
  - Stałe modelowe (próg detekcji, zakres szumów, etc.).
- [x] Stworzyć funkcję generującą trajektorie:
  - `generateTrajectory.m`: generuje trajektorie obiektów w przestrzeni.
  - Uwzględnić różne typy ruchu (np. jednostajny, zmienny).
- [x] Zaimplementować losowe generowanie pozycji i prędkości obiektów:
  - Funkcja losująca prędkości i kierunki.
- [x] Dodać symulację fałszywych trajektorii wynikających z szumów.

---

## 3. Symulacja działania radaru
- [x] Stworzyć model symulacyjny radaru:
  - `simulateRadar.m`: symuluje działanie radaru, generuje wykrycia.
- [x] Zaimplementować próg detekcji:
  - Uwzględnić szum na podstawie rozkładu Rayleigha.
  - Funkcja określająca, czy punkt jest wykryty (np. `isDetected.m`).
- [x] Dodać funkcjonalność symulacji błędów pomiarowych:
  - Szum procesowy i pomiarowy (parametryzowany sigma).

---

## 4. Analiza trajektorii i filtrowanie
- [ ] Zaimplementować filtrację danych:
  - Funkcja `kalmanFilter.m` do przetwarzania trajektorii.
  - Uwzględnić szum procesowy i szum pomiarowy.
- [ ] Stworzyć funkcję analizy trajektorii:
  - `analyzeTrajectory.m`: sprawdza, czy punkty należą do jednej trajektorii.
  - Wykorzystać odległość Mahalanobisa do obliczeń wiarygodności.
- [ ] Dodać wizualizację trajektorii:
  - Wyświetlić wykrycia na wykresie (prawdziwe i fałszywe trajektorie różnymi kolorami).

---

## 5. Generowanie danych do trenowania sieci neuronowej
- [ ] Stworzyć zbiór danych:
  - Generować trajektorie prawdziwe i fałszywe w różnych warunkach (różne poziomy szumów, różne progi detekcji).
  - Zapisz dane do plików w formacie kompatybilnym z MATLAB-em (np. `.mat`).
- [ ] Oznaczyć dane:
  - Oznaczyć dane jako prawdziwe lub fałszywe na podstawie wyników symulacji.
- [ ] Przygotować funkcję eksportującą dane:
  - `exportData.m`: zapisuje trajektorie i metadane do plików.

---

## 6. Implementacja sieci neuronowej
- [ ] Zaimportować toolbox do uczenia maszynowego.
- [ ] Stworzyć i trenować sieć:
  - Funkcja `trainNeuralNet.m` do trenowania sieci na wygenerowanych danych.
  - Testować różne konfiguracje sieci (np. liczbę warstw, neurony, funkcje aktywacji).
- [ ] Zaimplementować funkcję walidacji:
  - `validateModel.m`: ocenia skuteczność sieci na zbiorze testowym.

---

## 7. Walidacja wyników
- [ ] Przeprowadzić testy symulacyjne:
  - Weryfikować poprawność trajektorii na różnych poziomach szumu i progów detekcji.
- [ ] Analizować skuteczność algorytmu detekcji:
  - Obliczyć wskaźniki dokładności (precision, recall, etc.).
- [ ] Wizualizować wyniki:
  - Tworzyć wykresy porównawcze dla różnych scenariuszy.

---

## 8. Dokumentacja i przygotowanie wyników
- [ ] Udokumentować kod:
  - Dodać komentarze do wszystkich funkcji.
- [ ] Przygotować raport z wynikami:
  - Opisać wyniki symulacji, wnioski oraz skuteczność sieci neuronowej.
- [ ] Przygotować prezentację projektu:
  - Slajdy z wynikami i procesem implementacji.

---

## 9. Iteracyjne poprawki
- [ ] Poprawić błędy znalezione podczas testów.
- [ ] Optymalizować kod pod kątem wydajności.
- [ ] Konsultować się z promotorem i wdrażać jego uwagi.
