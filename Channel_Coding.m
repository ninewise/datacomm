classdef Channel_Coding
          
   methods(Static=true)
        
        % Functies voor Hamming codering
        function bitenc = Ham_encode(bitstring)
            % Functie die een bitstring encodeerd met de (11,15) Hamming code.
            % input:
            % bitstring: vector van ongecodeerde bits met lengte 1xN
            
            bitstring = bitstring(:)';  % zorg ervoor dat de input een rijvector is
            N = length(bitstring);
            N_codewords = ceil(N/11);            
            
            % voeg nullen aan de bitstring toe indien N niet deelbaar is
            % door een geheel aantal codewoorden
            bitstring = [bitstring zeros(1, N_codewords*11-N)];

            generator_matrix = [
                1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 ;
                0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 ;
                0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 ;
                0 0 0 1 0 0 0 0 0 0 0 1 1 0 1 ; 
                0 0 0 0 1 0 0 0 0 0 0 1 0 1 0 ;
                0 0 0 0 0 1 0 0 0 0 0 0 1 0 1 ;
                0 0 0 0 0 0 1 0 0 0 0 1 1 1 0 ;
                0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 ; 
                0 0 0 0 0 0 0 0 1 0 0 1 1 1 1 ;
                0 0 0 0 0 0 0 0 0 1 0 1 0 1 1 ;
                0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 ;   
            ];
        
            % Plaats de verschillende informatiewoorden op verschillende
            % rijen
            info_words = reshape(bitstring, [], N_codewords)';
            
            % Vervang elke rij (elk informatiewoord)
            % door zijn codewoord
            for i = 1:N_codewords
                bitenc(i,:) = info_words(i,:) * generator_matrix;
            end

            % output: de geencodeerde bits: lengte 15*N_codewords
            % example: bitenc = zeros(1, 15*N_codewords);
            
            % zet alles terug op 1 rij
            bitenc = reshape(bitenc', 1, [])
        end

        function bitdec = Ham_decode(bitenc)
            % Functie die een Hammingcode decodeerd (foutcorrectie)
            % input:
            % bitenc: vector met gecodeerde bits: lengte moet deelbaar zijn door 15
            
            bitenc = bitenc(:)';    % zorg ervoor dat de input een rijvector is
            N = length(bitenc);
            N_codewords = N/15;
            
            if(mod(N, 15) ~= 0)
                error('input is geen geheel aantal codewoorden.');
            end
                        
                       
            
            % output: de gedecodderde bits: lengte 11*N_codewords
            bitdec = zeros(1, 11*N_codewords);
        end

        % Functies voor de productcode
        function bitenc = Prod_encode(bitstring)
            % Functie die een bitstring encodeerd met de productcode.
            % input:
            % bitstring: vector van ongecodeerde bits met lengte 1xN
            
            bitstring = bitstring(:)';  % zorg ervoor dat de input een rijvector is
            N = length(bitstring);
            N_codewords = ceil(N/11/8);   
            
            % voeg nullen aan de bitstring toe indien N niet deelbaar is
            % door een geheel aantal codewoorden
            bitstring = [bitstring zeros(1, N_codewords*11*8-N)];

            % Product code hier
            
            % 1. Encodeer met Hamming code
            
            % Bereken de hamming codes voor alle 8 groepen van codewoorden
            ham_codes = Channel_Coding.Ham_encode(bitstring(:));
            
            % Herschaal zodat we telkens groepen van 8 codewoorden op 1
            % rij in de matrix hebben staan
            ham_codes = reshape(ham_codes, [], N_codewords)';
           
            % 2. Voeg pariteitsbits toe aan de output
            
            % Tel telkens de elementen in dezelfde "kolom" op
            % om zo de pariteitsbits te bekomen voor elk geencodeerd
            % codewoord
            % par_bits = zeros(N_codewords*8, 15);
            size(ham_codes)
            for i = 1:N_codewords
                for j = 1:15
                    par_bits(i,j) = sum( ham_codes(i, j:15:(8*15)) );
                end
            end
            
            bitenc = horzcat(ham_codes, par_bits);
            
            % output:
            % bitenc = zeros(1, (8+1)*15*N_codewords);
            
            % zet alles terug op 1 rij
            bitenc = reshape(bitenc', 1, [])
            
        end
        
        function bitdec = Prod_decode(bitenc)
            % Functie die een productcode decodeerd (foutcorrectie)
            % input:
            % bitenc: vector met gecodeerde bits: lengte moet deelbaar zijn door 15
            
            bitenc = bitenc(:)';    % zorg ervoor dat de input een rijvector is
            N = length(bitenc);
            N_codewords = N/15/(8+1);
            
            if(mod(N, 15*(8+1)) ~= 0)
                error('input is geen geheel aantal codewoorden.');
            end
            
            
            % errorcorrectie hier
            
            
            % output: de gedecodderde bits: lengte 11*8*N_codewords
            % bitdec = zeros(1, 11*8*N_codewords);
        end
        
        
    end
    
end