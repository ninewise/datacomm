classdef vraag2_2
    methods(Static)
        
        function [] = main()
            % Codewoorden & woorden bepalen
            n=15;
            k=11;
            infobits = vraag2_1.genereerInformatieBits(k);
            generator = [1 1 0 0 1 0 0 0 0 0 0 0 0 0 0];% x^4 + x + 1
            codewoorden = vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            
            % H_sys bepalen
            syst_generatormatrix=vraag2_1.genereerSystGeneratorMatrix(n, k, codewoorden);
            syst_checkmatrix=vraag2_1.genereerSystCheckMatrix(n, k, syst_generatormatrix);
            
            [syndromen cosetleiders] = vraag2_2.genereerSyndroomTabelImproved(n, syst_checkmatrix);
            
            
            % Syndroomtabel bepalen adhv decodeertabel
            % decodeertabel = vraag2_2.genereerDecodeerTabel(codewoorden,woorden, n, k);
            % syndroomtabel=vraag2_2.genereerSyndroomTabel(decodeertabel, syst_checkmatrix);
            % dlmwrite('vraag2_2/syndroomtabel(from decodeer).csv', syndroomtabel);
            
            dlmwrite('syndroomtabel.csv', [syndromen cosetleiders]);             
        end
        
        % Een 'iets' snellere versie voor syndroomtabel te maken (by Ruben)
        function [syndromen cosetleiders] = genereerSyndroomTabelImproved(n, syst_checkmatrix)
            cosetleiders=[zeros(1,n); eye(n)];
            syndromen=cosetleiders*syst_checkmatrix';
        end
        
        
        
        % Decodeertabel opstellen (niet nodig)
        function decodeertabel = genereerDecodeerTabel(codewoorden, woorden, n, k)
            
            decodeertabel = cell(bitshift(1,(n-k)),size(codewoorden, 1));
            
            for i = 1:bitshift(1,(n-k))
               % 1ste kolom
               [nextword minindex] = vraag2_2.findNextLightestWord(woorden);
               decodeertabel{i,1} = nextword;
               % Dit woord mag niet meer als kleinste gewicht woord gekozen
               % worden
               woorden(minindex,:) = 2;
               
               for j = 2:size(codewoorden, 1);
                  % plaats codewoord + somwoord
                  entry = mod((codewoorden(j,:) + decodeertabel{i,1}),2);
                  decodeertabel{i,j} = entry;
                  % Zorg dat dit woord niet als kleinste gewicht woord
                  % gekozen wordt
                  woorden(bi2de(entry,'left-msb')+1,:) = 2;
               end
               
            end
        end
        
        function [nextword minindex] = findNextLightestWord(woorden)
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
        
        % syndroomtabel opstellen adhv decodeertabel (niet nodig)
        function syndroomtabel = genereerSyndroomTabel(decodeertabel, checkmatrix)
            
            syndroomtabel = cell(size(decodeertabel,1),2);
            
            checkT = transpose(checkmatrix);
            % bereken syndromen en plaats ze met cosets in tabel
            for i = 1:size(decodeertabel,1)
               cosetleider = decodeertabel{i,1};
               syndroom = bi2de(cosetleider * checkT,'left-msb');
               syndroomtabel{i,1} = syndroom;
               syndroomtabel{i,2} = cosetleider;
            end
            
            % sorteer voor constant opzoeken
            syndroomtabel = sortrows(syndroomtabel,1);
            
            for i = 1:size(decodeertabel,1)
               syndroomtabel{i,1} = de2bi(syndroomtabel{i,1},size(checkT,2),'left-msb');
            end
            
        end
        
    end
end