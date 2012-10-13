% Main berekent het gemiddelde aantal codebits voor macroblokken van 1
% tot 10 bits en plot deze
classdef vraag1_4
    methods(Static)
        
        function [] = main()
            load('Xfile3.mat');
            for K = 1:1:10
                % Reken frequenties uit van macroblokken
                freqs = FrequencyCounter.calculate_frequencies(bitsrc, 1, K);
                % Stel alfabet op
                for i = 0:1:bitshift(1,K-1)
                    alf(i+1) = i;
                end
                alphabet = dec2bin(alf,K-1);
                %Stel Huffman-code op
                codewords = Source_Coding.create_codebook(alphabet,freqs);
                
                %debuglijn voor Enver: dit laat het codeboek zien en of er
                %nog lege arrayplekken zijn
                %codewords
                
                %bereken gemiddelde lengte van het aantal codebits
                avg_codebit(K) = mean(cellfun('length',codewords));
            end
            plot(avg_codebit);
            title(['Gemiddeld aantal codebits voor K=1..',10]);
            xlabel('K');
            ylabel('Gemiddeld aantal codebits');
        end
    end
end