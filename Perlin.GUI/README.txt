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
		01. Bitmap/CreateBMP																			  |
		02. Bitmap/GetPixelValues																		  |
		03. Bitmap/SinNoise																	     		  |
		04. Bitmap/SqrtNoise																			  |
		05. Bitmap/Experimental1																		  |
		06. Bitmap/Experimental2																		  |
		07. Bitmap/Experimental3																		  |
		08. Helpers/MaxMinFrom2DArray																	  |
		09. Perlin.Assembly/_Init																		  |
		10. Perlin.Assembly/Normalize																	  |
		11. Perlin.Assembly/_Finalize																	  |
	  																									  | 
	  Gotowe (nietestowane):																			  |
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