% Calling the main of this class (static) will make plots of the entropy
% of Darth Vader for K=1..10
classdef vraag1_3
    methods(Static)
        
        function [] = main()
                file='Xfile3.mat';
                data=load(file);
                amount=10;
                x=1:amount;
                e=zeros(amount);
                eref=e;
                for k=x
                    e(k)=vraag1_3.calcEntropy(vraag1_3.getFreqs(data.bitsrc,k));
                    am=bitshift(1, k);
                    eref(k)=vraag1_3.calcEntropy(repmat(1/am,am));
                end
                plot(x,e,x,eref);
                title(['Entropie voor K=1..10',10]);
                xlabel('K');
                ylabel('Entropie');
                legend(file,'Referentie');
        end
        
        function entropy = calcEntropy(freqs)
            freqs(freqs==0)=[];%strip de 0 elementen om geen NaN te bekomen
            [h w]=size(freqs);
            presum=zeros(1,w);
            for i=1:w
               presum(i)=freqs(i)*log2(freqs(i));
            end
            entropy=-sum(presum);
        end
        
        function freqs = getFreqs(data,k)
            [h w]=size(data);
            
            % Maak array met 2^(k) plaats.
            freqs = zeros(1, bitshift(1, k));
                for j = 0:k:(w - k),
                    value = 0;
                        for l = 0:k - 1,
                            % We lopen over het macroblock.
                            value = value * 2 + data(1,j + l + 1);
                        end
                    freqs(value + 1) = freqs(value + 1) + 1;
                end
            for i = 0:bitshift(1, k) - 1,
                freqs(i + 1) = freqs(i + 1) * ((k) / (w));
            end
        end
    end
end