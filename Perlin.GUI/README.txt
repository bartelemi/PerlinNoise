Program generujący pseudolosowe tekstury i (w przyszłości) animacje.


==========================================================================================================+
TODO:																									  |
																										  |
  ========================================================================================================+
  Perlin.GUI																							  |
	* Podgląd minatur w przeglądarkach plików															  |
	* Wyciągnąć inicjalizację wektora do Pelin.GUI żeby był jeden wektor na wszystkie wątki				  |
	                                                                                                      |
  ========================================================================================================+
  Perlin_C																								  | 
  * Dodać nowe efekty																					  |
  * Przerobić oryginalny generator Kena																	  |
  * Uporządkować kod																					  |
  * Naprawić błąd, powodujący naruszanie pamięci przy zwalnianiu wskaźnika na NoiseArrayDynamic			  |
  * Zapisywać każdą linię pikseli do jakiegoś bufora (unsigned char*), który potem należy zapisać         |
    w całości do wskaźnika na obraz unsigned int *imagePointer - unikniemy przesuwania po jednym bajcie   |
	w imagePointer (ten bufor będzie już wyrównany do 4 bajtów)                                           |
	 																									  |
  ========================================================================================================+
  Perlin_ASM																							  |
  * przepisać bibliotekę z C do asm															              |
																										  |
  ========================================================================================================+
  Czyszczenie																							  |
  * przywrócić defaultowe wartości dla generatora                                                         |
  * usunąć konsolę z Perlin.GUI.View.MainWindow.xaml.cs													  |
  * usunąć z Perlin.PureC z Helpers metodę printPointer oraz jej wszystkie wywołania					  |
  * usunąć również metody: printThreadParamInfo, PrintBMPInfo, SaveArrayToFile							  |
  * usunąć nieużywaną interpolację (cosinusową lub tą liniową)											  |
  * usunąć stare zakomentowane metody z PerlinNoise.c													  |
  * usunąć ten plik :)																					  |
																										  |
==========================================================================================================+