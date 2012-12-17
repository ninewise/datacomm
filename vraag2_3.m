classdef vraag2_3
   
    methods(Static)
        
        function misses = run(p, l)
            % Eerst en vooral bepalen we een random bitstring.
            bitstring = FakeChannel.random_bitstring(l);
            
            % Die kunnen we encoderen.
            bitenc = Channel_Coding.Ham_encode(bitstring);
            
            % We verzenden hem door ons valse kanaal.
            bitenc_ = FakeChannel.send(p, bitenc);
            
            % We decoderen de ontvangen bits.
            bitstring_ = Channel_Coding.Ham_decode(bitenc_);
            
            % Nu, het aantal bitfouten zou makkelijk te bepalen zijn, maar
            % we willen het aantal foute codewoorden weten. Daarvoor moeten
            % we de twee vectors omzetten naar matrices.
            bitstring = vec2mat(bitstring, 11);
            bitstring_ = vec2mat(bitstring_, 11);
            [height, ~] = size(bitstring);
            misses = (height - sum(all(bitstring == bitstring_, 2))) / height;
        end
        
        function misses = main
            % De verschillende kansen op bitfouten voor het kanaal.
            p = [.3 .1 .03 .01 .003 .001];
            
            % De lengte van bitstrings waarop we werken.
            l = 10000;
            
            misses = cell2mat(cellfun(@(k){vraag2_3.run(k, l)}, num2cell(p)));
        end

    end
end