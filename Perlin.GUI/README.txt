Program generujący pseudolosowe tekstury i (w przyszłości) animacje.

==========================================================================================================+
TODO:																									  |
																										  |
  ========================================================================================================+
  Perlin.GUI																							  |
	* Podgląd minatur w przeglądarkach plików															  |
	                                                                                                      |
  ========================================================================================================+
  Perlin_C																								  | 
  * Dodać nowe efekty																					  |
  * Przerobić oryginalny generator Kena																	  |
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
  * usunąć ten plik :)																					  |
																										  |
==========================================================================================================+