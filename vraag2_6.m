classdef vraag2_6
   
    methods(Static)
        
        function misses = run(p, l)
            % Eerst en vooral bepalen we een random bitstring.
            bitstring = FakeChannel.random_bitstring(l);
            
            % Die kunnen we encoderen.
            bitenc = Channel_Coding.Prod_encode(bitstring);
            
            % We verzenden hem door ons valse kanaal.
            bitenc_ = FakeChannel.send(p, bitenc);
            encl = size(bitenc,2);
            encmisses = encl - sum(bitenc == bitenc_(1:encl))
            % We decoderen de ontvangen bits.
            bitstring_ = Channel_Coding.Prod_decode(bitenc_);
            
            % Het aantal fouten:
            misses = l - sum(bitstring == bitstring_(1:l));
            misses
        end
        
        function misses = main
            % De verschillende kansen op bitfouten voor het kanaal.
            p = [.3 .1 .03 .01 .003 .001];
            
            % De lengte van bitstrings waarop we werken.
            l = 10000;
            
            misses = cell2mat(cellfun(@(k){vraag2_6.run(k, l)}, num2cell(p)));
            
            misses = misses / l;
            
        end

    end
end