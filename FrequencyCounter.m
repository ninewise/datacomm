classdef FrequencyCounter
    
    % Running this class when "darthvader.bmp" is moved in the MATLAB 
    % folder on your H:\ folder will output the relative frequencies
    % of the macroblocks.
    
    methods(Static)
        
        function [] = main()
            darth_vader = imread('darthvader.bmp', 'bmp');
            freqs = FrequencyCounter.calculate_frequencies(darth_vader, 2, 2);
            freqs
        end
        
        function freqs = calculate_frequencies(matrix, blockheight, blockwidth)
            [height, width] = size(matrix);
            % Maak array met 2^(blockwidth * blockheight) plaats.
            freqs = zeros(1, bitshift(1, blockwidth * blockheight));
            for i = 0:blockheight:(height - blockheight),
                for j = 0:blockwidth:(width - blockwidth),
                    % De (i,j) zijn de linkerbovenhoeken.
                    value = 0;
                    for k = 0:blockheight - 1,
                        for l = 0:blockwidth - 1,
                            % We lopen over het macroblock.
                            value = value * 2 + matrix(i + k + 1, j + l + 1);
                        end
                    end
                    freqs(value + 1) = freqs(value + 1) + 1;
                end
            end
            for i = 0:bitshift(1, blockwidth * blockheight) - 1,
                freqs(i + 1) = freqs(i + 1) * (blockwidth * blockheight) / (width * height);
            end
        end
        
    end
    
end