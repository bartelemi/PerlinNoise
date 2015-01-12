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
		2. Bitmap/Experimental1																			  |
		3. Bitmap/Experimental2																			  |
		4. Bitmap/Experimental3																			  |
																										  |
	  Gotowe (testowane):																				  |
		Bitmap/SqrtNoise																		 		  |
		PerlinNoise/PerlinNoise2D																	      |																				  |
	    PerlinNoise/Noise																				  | 
		PerlinNoise/Setup																				  |
		Perlin.Assembly/_Init																			  |
		Perlin.Assembly/_PerlinNoise																	  |
		PerlinNoise/at2					OK																  |
		Perlin.Assembly/_Finalize		OK																  |
		Helpers/MaxMin					OK																  |
		Helpers/EaseCurve				OK C-tested														  | 
		Helpers/LineraInterpolation		OK C-tested														  |
		Helpers/Power					OK C-tested														  |
		Helpers/memCopy					OK C-tested														  | 
		Bitmap/GetColor					OK C-tested													      |
		Bitmap/ScaleToChar				OK C-tested													      |
		Bitmap/CreateBMP				OK C-tested														  |
		Bitmap/GetPixelValues			OK C-tested														  |
		Bitmap/WriteFileHeader			OK C-tested														  |
																										  |
==========================================================================================================+

==========================================================================================================+
TIPS&TRICKS:																							  |
For a two-dimension column major array:																	  |
Element_Address = Base_Address + (rowindex * col_size + colindex) * Element_Size						  |
																										  |
==========================================================================================================+
Wielowątkowość:
	Prawdopodobnie wysypuje się przez MersenneTwister - następny stan generatora etc.

Optymalizacja ASM: