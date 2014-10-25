Program generujący pseudolosowe tekstury i (w przyszłości) animacje.


==========================================================================================================+
TODO:																									  |
																										  |
  ========================================================================================================+
  Perlin.GUI																							  | 		
    * zaimplementować podział na wątki																	  |
	* zaimplementować odpowiednią komunikację pomiędzy GUI a DLL - jest już (chyba) odpowiednia struktura |
    * zaimplementować maszynę stanów w programie - wykorzystanie enuma GeneratorState					  |
	* zaimplementować karty w konfiguracji - mają być osobne karty na ustawienia ogólne                   |
	  (libka/typ/rozmiary), ustawienia generatora (liczba oktaw, persystancja, etc.),                     |
	  ustawienia gifa oraz bitmapy (kolor/efekt)                                                          |
	* na stronie konfiguracji po wygenerowaniu pliku ma on zostać wyświetlony oraz ma sie wtedy pojawić   |
	  przycisk do zapisu, a przycisk Generuj ma zmienić nazwę na "generuj nowy", jednakże jego naciśnięcie|
	  powoduje ostrzeżenie o niezapisaniu wcześniej wygenerowanego pliku.								  |
																										  |
	* podgląd minatur w przeglądarkach plików															  |
  ========================================================================================================+
  Perlin_C									  														      |
  * przerobić bibliotekę, tak by przyjmowała tablicę bajtów i zwracała wypełnioną						  |  
  * biblioteka ma umożliwiać wybranie efektu przez parametr												  |
  * biblioteka ma umożliwiać wybranie koloru przez parametr												  |
                                                                                                          |
																										  |
  ========================================================================================================+
  Perlin_ASM																							  |
  * przepisać bibliotekę z C do asm															              |
																										  |
==========================================================================================================+