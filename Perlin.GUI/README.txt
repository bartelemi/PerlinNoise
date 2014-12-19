Program generujący pseudolosowe tekstury i (w przyszłości) animacje.

==========================================================================================================+
TODO:																									  |
																										  |
  ========================================================================================================+
  Perlin.GUI																							  |
	* Podgląd minatur w przeglądarkach plików															  |
	                                                                                                      |
  ========================================================================================================+
  Perlin.PureC																							  |
  * Zapisywać każdą linię pikseli do jakiegoś bufora (unsigned char*), który potem należy zapisać         |
    w całości do wskaźnika na obraz unsigned int *imagePointer - unikniemy przesuwania po jednym bajcie   |
	w imagePointer (ten bufor będzie już wyrównany do 4 bajtów)                                           |
	 																									  |
  ========================================================================================================+
  Perlin.Assembly																						  |
  * funkcje 																							  | 
      TBD:																								  |
		1. Bitmap/SinNoise																	     		  |
		2. Bitmap/SqrtNoise																				  |
		3. Bitmap/Experimental1																			  |
		4. Bitmap/Experimental2																			  |
		5. Bitmap/Experimental3																			  |
		6. Helpers/MaxMinFrom2DArray																	  |
		7. Perlin.Assembly/_Init																		  |
		8. Perlin.Assembly/_Finalize																	  |
	  																									  | 
	  Gotowe (nietestowane):																			  |
		Bitmap/CreateBMP																				  |
		Bitmap/GetPixelValues																			  |
	    Bitmap/ScaleToChar																			      |
		Bitmap/GetColor																					  |
		Helpers/Alloc2DArray																		      |
	    Helpers/EaseCurve																				  | 
		Helpers/LineraInterpolation																		  |
		Helpers/Power																					  | 
		Perlin.Assembly/_PerlinNoiseBmp																	  |
		PerlinNoise/Noise																				  | 
		PerlinNoise/PerlinNoise2D																	      |
		PerlinNoise/Setup																				  |
		PerlinNoise/at2																					  |
		Perlin.Assembly/Normalize																		  |
																										  |
	  Gotowe (testowane):																				  |
		Helpers/memCopy																					  |
		Bitmap/FillHeader																				  |
		Bitmap/WriteFileHdr																				  |
																										  |
  ========================================================================================================+
  Czyszczenie																							  |
  * usunąć ten plik :)																					  |
																										  |
==========================================================================================================+

==========================================================================================================+
TIPS&TRICKS:																							  |
For a two-dimension column major array:																	  |
Element_Address = Base_Address + (rowindex * col_size + colindex) * Element_Size						  |
																										  |
==========================================================================================================+

Optymalizacja ASM:

	PerlinNoise: sprawdzić co w jakich pętlach się zmienia i przenieść jakieś
				 najczęściej używane wartości do rejestrów xmm na stałe (np. wartość 100)