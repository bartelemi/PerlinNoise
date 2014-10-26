Program generujący pseudolosowe tekstury i (w przyszłości) animacje.


==========================================================================================================+
TODO:																									  |
																										  |
  ========================================================================================================+
  Perlin.GUI																							  |
	* dodać validację, żeby do textboxa z rozmiarem można było wpisać tylko cyfry                         | 		
    * zaimplementować podział na wątki	-- chyba jest													  |
	* zaimplementować odpowiednią komunikację pomiędzy GUI a DLL                                          |
    * zaimplementować maszynę stanów w programie - wykorzystanie enuma GeneratorState					  |
	* poprawić widok karty konfiguracji                                                                   |
	* na stronie konfiguracji po wygenerowaniu pliku ma on zostać wyświetlony oraz ma sie wtedy pojawić   |
	  przycisk do zapisu, a przycisk Generuj ma zmienić nazwę na "generuj nowy", jednakże jego naciśnięcie|
	  powoduje ostrzeżenie o niezapisaniu wcześniej wygenerowanego pliku.								  |
	* zaimplementować pole z obliczaniem czasu generacji obiektu - stoper już jest                        |
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