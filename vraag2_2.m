classdef vraag2_2
    methods(Static)
        
        function [] = main()
            % Codewoorden bepalen
            n=15;
            k=11;
            [infobits rows]=vraag2_1.genereerInformatieBits(k);
            generator=[1 1 0 0 1 0 0 0 0 0 0 0 0 0 0];% x^4 + x + 1
            [codewoorden rows]=vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            % H_sys bepalen
            syst_generatormatrix=vraag2_1.genereerSystGeneratorMatrix(n, k, codewoorden);
            syst_checkmatrix=vraag2_1.genereerSystCheckMatrix(n, k, syst_generatormatrix);
            % Syndroomtabel bepalen
            decodeertabel = vraag2_2.genereerDecodeerTabel(codewoorden, n, k);
            syndroomtabel=vraag2_2.genereerSyndroomTabel(decodeertabel, syst_checkmatrix);
            
            dlmwrite('vraag2_2/syndroomtabel.csv', syndroomtabel);
            
            
        end
        
        function decodeertabel = genereerDecodeerTabel(codewoorden, n, k)
            info = vraag2_1.genereerInformatieBits(n);
            
            for i = 1:bitshift(1,(n-k))
               % 1ste kolom
               nextword = vraag2_2.findNextLightestWord(info);
               decodeertabel{i,1} = nextword;
               info(bi2de(nextword,'left-msb')+1,:) = 2;
               
               for j = 2:size(codewoorden, 1);
                  % plaats codewoord + somwoord
                  entry = mod((codewoorden(j,:) + decodeertabel{i,1}),2);
                  decodeertabel{i,j} = entry;
                  % Zorg dat dit woord niet als kleinste gewicht woord
                  % gekozen wordt
                  info(bi2de(entry,'left-msb')+1,:) = 2;
               end
               
            end
        end
        
        function nextword = findNextLightestWord(woorden)
            weights = sum(woorden,2);
            minweight = size(woorden,2) + 1;
            for i = 1:size(woorden,1)
                if(weights(i) < minweight)
                    minindex = i;
                    minweight = weights(i);
                end
            end
            nextword = woorden(minindex,:);
        end
        
        function syndroomtabel = genereerSyndroomTabel(decodeertabel, checkmatrix)
            checkT = transpose(checkmatrix);
            for i = 1:size(decodeertabel,1)
               cosetleider = decodeertabel{i,1};
               syndroomtabel{i,1} = cosetleider * checkT; 
               syndroomtabel{i,2} = cosetleider; 
            end
        end
    end
end