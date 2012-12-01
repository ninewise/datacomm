classdef vraag2_1
    methods(Static)
        
        function [] = main()
            n=15;
            k=11;
            generator=[1 1 0 0 1 0 0 0 0 0 0 0 0 0 0];% x^4 + x + 1
            [infobits rows]=vraag2_1.genereerInformatieBits(k);
            [codewoorden rows]=vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            dist=vraag2_1.minimaleHammingAfstand(codewoorden)
        end
        
        function [info rows] = genereerInformatieBits(k)
            rows=bitshift(1, k);
            info=zeros(rows,k);
            bin = dec2bin(0:rows-1,k);
            for i = 1:k
               info(:,i) = str2num(bin(:,i)); 
            end
        end
        
        function [codes rows] = genereerCodeWoorden(n, k, infobits, generator)
            rows=bitshift(1, k);
            codes=zeros(rows, n);
            for i = 1:rows
                for j = 1:k
                    if(infobits(i, j))
                        for t = 1:n-j+1
                            codes(i, t+j-1)=mod(codes(i, t+j-1) + generator(1, t), 2);
                        end
                    end
                end
            end
        end
        
        function [dist] = minimaleHammingAfstand(codes)
            codes(all(codes==0,2),:)=[];
            dist=min(sum(codes,2));
        end
    end
end