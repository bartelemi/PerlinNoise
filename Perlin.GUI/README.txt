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
	  																									  | 
	  Gotowe (nietestowane):																			  |
		PerlinNoise/PerlinNoise2D																	      |
																										  |
	  Gotowe (testowane):																				  |
		Helpers/MaxMin																					  |
		Helpers/memCopy																					  |
		Helpers/Power																					  | 
		Bitmap/GetColor																				      |
		Bitmap/FillHeader																				  |
		Bitmap/WriteFileHdr																				  |
		Bitmap/ScaleToChar																			      |
		Bitmap/CreateBMP			(raczej wsio ok)													  |
		Bitmap/GetPixelValues		(raczej wsio ok)													  |
	    PerlinNoise/Noise			(raczej wsio ok)													  | 
		PerlinNoise/at2																					  |
		PerlinNoise/Setup																				  |
		Helpers/EaseCurve																				  | 
		Helpers/LineraInterpolation																		  |
		Perlin.Assembly/_Init																			  |
		Perlin.Assembly/Normalize																		  |
		Perlin.Assembly/_PerlinNoise																	  |
		Perlin.Assembly/_Finalize																		  |
																										  |
==========================================================================================================+

==========================================================================================================+
TIPS&TRICKS:																							  |
For a two-dimension column major array:																	  |
Element_Address = Base_Address + (rowindex * col_size + colindex) * Element_Size						  |
																										  |
==========================================================================================================+

Optymalizacja ASM:
	Normailize: nie przerzucać z pamięci do pamięci, tylko zostawić wartość w xmm0 i wywołać Normalize