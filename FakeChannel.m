
classdef FakeChannel

    % Deze klasse doet het binair symmetrisch kanaal na.
    
    methods(Static)
        
        % Genereert een random bitstring van lengte length. Handig om data
        % te verkrijgen om over het kanaal te verzenden.
        function bitstring = random_bitstring(length)
            bitstring = cell(1, length);
            bitstring = cellfun(@(~){random('bino', 1, .5)}, bitstring);
            bitstring = cell2mat(bitstring);
        end

        function out = send(p, in)
            % in is de data die verzonden wordt. Als het een matrix is,
            % lezen we die rij per rij in.
            in = in';
            in = in(:)';

            % p is de kans op een bitflip.

            % we flippen elk element uit in met een kans p:
            out = cellfun(@(b){b + random('Binomial', 1, p)}, num2cell(in));
            out = mod(cell2mat(out), 2);
        end

    end

end
