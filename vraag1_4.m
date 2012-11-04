% Main berekent het gemiddelde aantal codebits voor macroblokken van 1
% tot 10 bits en plot deze
classdef vraag1_4
    methods(Static)
        
        function [] = main()
            load('Xfile3.mat');
            avg_codebit = zeros(1,10);
            lower_bound = zeros(1,10);
            upper_bound = zeros(1,10);
            for K = 1:1:10
                
                % Reken frequenties uit van macroblokken
                freqs = FrequencyCounter.calculate_frequencies(bitsrc, 1, K);
                
                % Stel alfabet op
                for i = 0:1:bitshift(1,K)-1
                    alf(i+1) = i;
                end
                alphabet =  cellstr(dec2bin(alf));
                
                % Stel Huffman-code op
                codewords = Source_Coding.create_codebook(alphabet,freqs);
                
                % Bereken gemiddelde aantal codebits per bronsymbool
                % en ondergrens
                codelengths = cellfun('length',codewords);
                sum = 0;
                for i = 1:1:bitshift(1,K)
                    sum = sum + codelengths(i) * freqs(i);
                end
                
                entropy = vraag1_3.calcEntropy(freqs);
                lower_bound(K) = entropy/K;
                avg_codebit(K) = sum/K;
                upper_bound(K) = (sum + (1/entropy))/K;
            end
            
            % Plot resultaat
            x = 1:1:10;
            plot(x,lower_bound, x,avg_codebit, x,upper_bound);
            title(['Gemiddeld aantal codebits voor macroblok lengte 1..10']);
            xlabel('Lengte macroblok');
            ylabel('Gemiddeld aantal codebits per bronsymbool');
            legend('Ondergrens','Gemiddeld aantal codebits/symbool','Bovengrens');
        end
    end
end