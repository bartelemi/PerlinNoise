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
  * Przerobić oryginalny generator Kena																	  |
  * Zapisywać każdą linię pikseli do jakiegoś bufora (unsigned char*), który potem należy zapisać         |
    w całości do wskaźnika na obraz unsigned int *imagePointer - unikniemy przesuwania po jednym bajcie   |
	w imagePointer (ten bufor będzie już wyrównany do 4 bajtów)                                           |
	 																									  |
  ========================================================================================================+
  Perlin.Assembly																						  |
  * przepisać bibliotekę z C do asm															              |
  * funkcje 																							  | 
      TBD:																								  |
		Bitmap/CreateBMP																				  |
		Bitmap/GetPixelValues																			  |
		Bitmap/GetColor																					  |
		Bitmap/GetColorReversed																		      |
		Bitmap/SinNoise																		     		  |
		Bitmap/SqrtNoise																				  |
		Bitmap/Experimental1																			  |
		Bitmap/Experimental2																			  |
		Bitmap/Experimental3																			  |
		Bitmap/ScaleToChar																			      |
		Helpers/Alloc2DArray																			  |
		Helpers/MaxMinFrom2DArray																		  |
		Perlin.Assembly/_Init																			  |
		Perlin.Assembly/Normalize																		  |
		Perlin.Assembly/_Finalize																		  |
		PerlinNoise/PerlinNoise2D																	      |
		PerlinNoise/Noise																				  | 
	  																									  | 
	  Gotowe (nietestowane):																			  |
		Helpers/Free2DArray																				  |
	    Helpers/EaseCurve																				  | 
		Helpers/LineraInterpolation																		  |
		Helpers/Power																					  | 
		Perlin.Assembly/_PerlinNoiseBmp																	  |
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
