% Main berekent het gemiddelde aantal codebits voor macroblokken van 1
% tot 10 bits en plot deze
classdef vraag1_4
    methods(Static)
        
        function [] = main()
            load('Xfile3.mat');
            for K = 1:1:15
                
                % Reken frequenties uit van macroblokken
                freqs = FrequencyCounter.calculate_frequencies(bitsrc, 1, K);
                
                % Stel alfabet op
                for i = 0:1:bitshift(1,K)-1
                    alf(i+1) = i;
                end
                alphabet = dec2bin(alf);
                
                % Stel Huffman-code op
                codewords = Source_Coding.create_codebook(alphabet,freqs);
                
                % Bereken gemiddelde aantal codebits per bronsymbool
                codelengths = cellfun('length',codewords);
                sum = 0;
                for i = 1:1:bitshift(1,K)
                    sum = sum + codelengths(i) * freqs(i);
                end
                avg_codebit(K) = sum/K;
            end
            
            % Plot resultaat
            plot(avg_codebit);
            title(['Gemiddeld aantal codebits voor macroblok lengte 1..10',15]);
            xlabel('Lengte macroblok');
            ylabel('Gemiddeld aantal codebits per bronsymbool');
        end
    end
end