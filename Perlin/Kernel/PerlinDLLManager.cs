﻿using System.Threading.Tasks;
using Perlin.GUI.Models;
using Perlin.GUI.Models.RunParameters;

namespace Perlin.GUI.Kernel
{
    /// <summary>
    /// Bridge between GUI and DLL functions.
    /// Provides exchange of data gained from user and data generated by program.
    /// It's also obligated to divide word for threads.
    /// </summary>
    class PerlinDllManager
    {
        #region Import DLLs
        //[DllImport("Perlin.PureC.dll", EntryPoint = "GeneratePerlinNoiseBitmap", CallingConvention = CallingConvention.StdCall)]
        //private static extern void GeneratePerlinNoiseBitmapPureC(ThreadParameters threadParameters);
        //[DllImport("Perlin.PureC.dll", EntryPoint = "GeneratePerlinNoiseGif", CallingConvention = CallingConvention.StdCall)]
        //private static extern void GeneratePerlinNoiseGifPureC(ThreadParameters threadParameters);

        //[DllImport("Perlin.Asm.dll", EntryPoint = "GeneratePerlinNoiseBitmap")]
        //private static extern void GeneratePerlinNoiseBitmapAssembly(ThreadParameters threadParameters);
        //[DllImport("Perlin.Asm.dll", EntryPoint = "GeneratePerlinNoiseGif")]
        //private static extern void GeneratePerlinNoiseGifAssembly(ThreadParameters threadParameters);
        #endregion // Import DLLs

        #region Fields
        private readonly GeneratorParameters _generatorParameters; 
        private byte[] GeneratedFileArray { get; set; }
        #endregion // Fields

        #region Constructor
        public PerlinDllManager(GeneratorParameters generatorParameters)
        {
            _generatorParameters = generatorParameters;
        }
        #endregion // Constructor
        public async Task<byte[]> GeneratePerlinNoiseFileAsync()
        {
            var tasks = new Task[_generatorParameters.NumberOfThreads];

            for (int thread = 0; thread < tasks.Length; thread++)
            {
                var tempThread = thread;
                tasks[thread] = Task.Run(() =>
                {
                    var thisThreadParams = ComputeThreadParameters(tempThread);
                    RunSingleThread(thisThreadParams);
                });
            }
            await Task.WhenAll(tasks);

            return GeneratedFileArray;
        }

        private ThreadParameters ComputeThreadParameters(int threadId)
        {
            var thisThreadFileHeight = 0;
            var currentOffset = 0;
            for (int i = 0; i <= threadId; i++)
            {
                thisThreadFileHeight = ComputeNumberOfLinesForCurrentThread(i);
                if (i != threadId)
                    currentOffset += thisThreadFileHeight;
            }
            return new ThreadParameters()
            {
                IdOfThread = threadId,
                NumberOfThreads = _generatorParameters.NumberOfThreads,
                CurrentImageOffset = currentOffset,
                ImageWidth = _generatorParameters.GeneratingBitmapParameters.Width,
                ImageHeight = thisThreadFileHeight,
                NoiseColor = (int)_generatorParameters.GeneratingBitmapParameters.NoiseColorBmp,
                NoiseEffect = (int)_generatorParameters.GeneratingBitmapParameters.NoiseEffectsBmp
            };
        }

        private int ComputeNumberOfLinesForCurrentThread(int threadId)
        {
            var numberOfThreads = _generatorParameters.NumberOfThreads;
            var imgHeight = _generatorParameters.GeneratingBitmapParameters.Height;
            var numberOfLines = (imgHeight / numberOfThreads);

            if (numberOfThreads > 1)
            {
                if((numberOfLines % numberOfThreads) != 0)
                {
                    if (threadId == (numberOfThreads - 1))
                    {
                        numberOfLines = (imgHeight - (threadId * numberOfLines));
                    }
                }
            }
            return numberOfLines;
        }

        private unsafe void RunSingleThread(ThreadParameters currendThreadParameters)
        {
            fixed (byte* fileArray = GeneratedFileArray)
            {
                currendThreadParameters.ImageByteArrayPointer = (uint*) (&fileArray);

                if (_generatorParameters.GeneratingLibrary == Library.PureC)
                {
                    if (_generatorParameters.GeneratedFileType == FileType.Bitmap)
                    {
                        //GeneratePerlinNoiseBitmapPureC(currendThreadParameters);   
                    }
                    else
                    {
                        //GeneratePerlinNoiseGifPureC(currendThreadParameters);  
                    }
                }
                else
                {
                    if (_generatorParameters.GeneratedFileType == FileType.Bitmap)
                    {
                        //GeneratePerlinNoiseBitmapAssembly(currendThreadParameters);    
                    }
                    else
                    {
                        //GeneratePerlinNoiseGifAssembly(currendThreadParameters);   
                    }
                }
            }
        }
    }
}
