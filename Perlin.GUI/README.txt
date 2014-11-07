Program generujący pseudolosowe tekstury i (w przyszłości) animacje.


==========================================================================================================+
TODO:																									  |
																										  |
  ========================================================================================================+
  Perlin.GUI																							  |
	* dodać validację, żeby do textboxa z rozmiarem można było wpisać tylko cyfry                         |
    * zaimplementować maszynę stanów w programie - wykorzystanie enuma GeneratorState					  |
	* poprawić widok karty konfiguracji                                                                   |
	* zaimplementować do końca stoper - pomiar czasu generacji pliku (brak pola na GUI oraz powiązania)   |
	* na stronie konfiguracji po wygenerowaniu pliku ma on zostać wyświetlony oraz ma sie wtedy pojawić   |
	  przycisk do zapisu, a przycisk Generuj ma zmienić nazwę na "generuj nowy", jednakże jego naciśnięcie|
	  powoduje ostrzeżenie o niezapisaniu wcześniej wygenerowanego pliku.								  |
	* podgląd minatur w przeglądarkach plików															  |
  ========================================================================================================+
  Perlin_C																								  |
  * jak rozwiązać problem, z nagłówkiem pliku? - pierwszy wątek ma go tworzyć?                            |
  * bład w pliku Bitmap.c - ma lecieć po kolei 0,1,2,3... po NoiseArrayDynamic, ale do wskaźnika ma       |
    zapisywać wyrównane dane                                                                              | 
  * przerobić bibliotekę, tak by przyjmowała ThreadParameters		                                      |
																										  |
  ========================================================================================================+
  Perlin_ASM																							  |
  * zmienić na Perlin.Asm (konwencja nazw)  														      |
  * przepisać bibliotekę z C do asm															              |
																										  |
==========================================================================================================+