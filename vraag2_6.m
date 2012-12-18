classdef vraag2_6
   
    methods(Static)
        
        function aantalfouten = run(p, l)
            % We bepalen de lengte van de bitstring
            stringlength = 11 * l;
            blockamount = 8;

            % Eerst en vooral bepalen we een random bitstring.
            bitstring = FakeChannel.random_bitstring(stringlength);
            
            % Die kunnen we encoderen.
            bitenc = Channel_Coding.Prod_encode(bitstring);
            
            % We verzenden hem door ons valse kanaal.
            bitenc_ = FakeChannel.send(p, bitenc);

            % We decoderen de ontvangen bits.
            bitstring_ = Channel_Coding.Prod_decode(bitenc_);

            % Nu, het aantal bitfouten zou makkelijk te bepalen zijn, maar
            % we willen het aantal foute codewoorden weten. Daarvoor moeten
            % we de twee vectorss omzetten naar matrices.
            bitstring = vec2mat(bitstring, 11*blockamount);
            bitstring_ = vec2mat(bitstring_, 11*blockamount);
            [height, ~] = size(bitstring);             
            aantalfouten = (height - sum(all(bitstring == bitstring_, 2))) * blockamount;
        end
        
        function aantalfouten = main
            % De verschillende kansen op bitfouten voor het kanaal.
            p = [.3 .1 .03 .01 .003 .001];
            analytisch = [10000 9917 4546 745 73 8];
            
            % De lengte van bitstrings waarop we werken in woorden.
            l = 10000;
            
            % Vind aantal foute woorden en zet om naar %
            aantalfouten = cell2mat(cellfun(@(k){vraag2_6.run(k, l)}, num2cell(p))) / l * 100;       
            dlmwrite('prod_simulaties.csv', [p' analytisch' aantalfouten']); 
        end

    end
end