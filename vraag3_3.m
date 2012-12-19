classdef vraag3_3
    
    methods(Static)
        
        function [] = test
            darth_vader = imread('darthvader.bmp', 'bmp');
            [height, width] = size(darth_vader);
            freqs = FrequencyCounter.calculate_frequencies(darth_vader, 2, 2);
            darth_vader_reshaped = vraag3_3.img_to_row(darth_vader, 2, 2);
            symbols = 0:(length(freqs)-1);
            
            codewords = Source_Coding.create_codebook(symbols, freqs);
            codelengths = cellfun('length',codewords);
            
            
            codewords_canonical = Source_Coding.create_canonical_codebook(symbols, codelengths);
            compressed_canonical_src = Source_Coding.Huffman_encode(darth_vader_reshaped, symbols, codewords_canonical);
            
            uncompressed_canonical = Source_Coding.Huffman_decode(compressed_canonical_src, symbols, codewords_canonical);
            uncompressed_canonical = vraag3_3.row_to_img(uncompressed_canonical, 2, 2, width, height);
            
            figure
            subplot(1, 2, 1);
            imshow(~darth_vader);
            title('origineel');
            subplot(1, 2, 2);
            imshow(~uncompressed_canonical);
            title('canonisch gedecodeerd');
        end
        
        function [] = main
           darth_vader = imread('darthvader.bmp', 'bmp');
           darth_vader_reshaped = vraag3_3.img_to_row(darth_vader, 2, 2);
           p = 0.01;
           [height, width] = size(darth_vader);
           
           freqs = FrequencyCounter.calculate_frequencies(darth_vader, 2, 2);
     
           symbols = 0:(length(freqs)-1); % symbolen voorgesteld door getallen
           
           % Merk op: afbeeldingen worden geinverteerd weggeschreven
           % omdat matlab ze geinverteerd inleest
           
           % Zonder codering en compressie
           uncoded_uncompressed = FakeChannel.send(p, darth_vader);
           uncoded_uncompressed = reshape(uncoded_uncompressed, height, width);
           imwrite(~uncoded_uncompressed, 'vraag3_3/uncoded_uncompressed.bmp', 'bmp');
           
           % Gecomprimeerd (2 x 2 blokken) met gewone Huffman
           codewords = Source_Coding.create_codebook(symbols, freqs);
           compressed_src = Source_Coding.Huffman_encode(darth_vader_reshaped, symbols, codewords);
           compressed_rec = FakeChannel.send(p, compressed_src);
           compressed = Source_Coding.Huffman_decode(compressed_rec, symbols, codewords);
           compressed = vraag3_3.row_to_img(compressed, 2, 2, width, height);
           imwrite(~compressed, 'vraag3_3/compressed.bmp', 'bmp');
           
           % Gecomprimeerd (2 x 2 blokken) met canonische Huffman
           codelengths = cellfun('length',codewords);
           codewords_canonical = Source_Coding.create_canonical_codebook(symbols, codelengths);
           compressed_canonical_src = Source_Coding.Huffman_encode(darth_vader_reshaped, symbols, codewords_canonical);
           compressed_canonical_rec = FakeChannel.send(p, compressed_canonical_src);
           compressed_canonical = Source_Coding.Huffman_decode(compressed_canonical_rec, symbols, codewords_canonical);
           compressed_canonical = vraag3_3.row_to_img(compressed_canonical, 2, 2, width, height);
           imwrite(~compressed_canonical, 'vraag3_3/compressed_canonical.bmp', 'bmp');
            
           % Gecomprimeerd en gecodeerd (met productcode en gewone Huffman)
           coded_compressed_src = Channel_Coding.Prod_encode(compressed_src);
           coded_compressed_rec = FakeChannel.send(p, coded_compressed_src);
           coded_compressed = Channel_Coding.Prod_decode(coded_compressed_rec);
           coded_compressed = Source_Coding.Huffman_decode(coded_compressed, symbols, codewords);
           coded_compressed = vraag3_3.row_to_img(coded_compressed, 2, 2, width, height);
           imwrite(~coded_compressed, 'vraag3_3/coded_compressed.bmp', 'bmp');
           
           % Gecomprimeerd en gecodeerd (met productcode en canonische Huffman)
           coded_compressed_canonical_src = Channel_Coding.Prod_encode(compressed_canonical_src);
           coded_compressed_canonical_rec = FakeChannel.send(p, coded_compressed_canonical_src);
           coded_compressed_canonical = Channel_Coding.Prod_decode(coded_compressed_canonical_rec);
           coded_compressed_canonical = Source_Coding.Huffman_decode(coded_compressed_canonical, symbols, codewords_canonical);
           coded_compressed_canonical = vraag3_3.row_to_img(coded_compressed_canonical, 2, 2, width, height);
           imwrite(~coded_compressed_canonical, 'vraag3_3/coded_compressed_canonical.bmp', 'bmp');
           
           % Output in matlab
           figure
           subplot(2, 3, 1);
           title('ongecomprimeerd en ongecodeerd');
           imshow(~uncoded_uncompressed);
           
           subplot(2, 3, 2);
           title('gecomprimeerd, gewone huffman');
           imshow(~compressed);
           
           subplot(2, 3, 3);
           title('gecomprimeerd, canonische huffman');
           imshow(~compressed_canonical);
           
           subplot(2, 3, 4);
           title('gewone huffman, gecodeerd');
           imshow(~coded_compressed);
           
           subplot(2, 3, 5);
           title('canonische huffman, gecodeerd');
           imshow(~coded_compressed_canonical);
        end
        
        function row = img_to_row(img, blockheight, blockwidth)
            % Zet een ingeladen afbeelding om naar een enkele
            % rijmatrix waarbij de macrosymbolen met grootte
            % blockheight x blockwidth achter elkaar staan.
            
            [height, width] = size(img);
            % Maak array met 2^(blockwidth * blockheight) plaats.
            row = zeros(1, (height*width)/(blockheight*blockwidth));
            for i = 0:blockheight:(height - blockheight),
                for j = 0:blockwidth:(width - blockwidth),
                    % De (i,j) zijn de linkerbovenhoeken.
                    value = 0;
                    for k = 0:blockheight - 1,
                        for l = 0:blockwidth - 1,
                            % We lopen over het macroblock.
                            value = value * 2 + img(i + k + 1, j + l + 1);
                        end
                    end
                    row(i/blockheight * width/blockwidth + j/blockwidth + 1) = value;
                end
            end
        end
        
        function matrix = row_to_img(row, blockheight, blockwidth, width, height)
            matrix = zeros(height, width);
            for i = 0:blockheight:(height - blockheight),
                for j = 0:blockwidth:(width - blockwidth),
                    % De (i,j) zijn de linkerbovenhoeken.
                    
                    index = i/blockheight * width/blockwidth + j/blockwidth + 1;
                    if index > numel(row)
                        value = 0;
                    else
                        value = row(index);
                    end
                    
                    for k = (blockheight - 1):-1:0,
                        for l = (blockwidth - 1):-1:0,
                            % We lopen over het macroblock.
                            matrix(i + k + 1, j + l + 1) = mod(value, 2);
                            value = bitshift(value, -1);
                        end
                    end
                end
            end
        end
        
    end
    
end