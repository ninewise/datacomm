classdef vraag2_1
    methods(Static)
        
        function [] = main()
            n=15;
            k=11;
            generator=[1 1 0 0 1 0 0 0 0 0 0 0 0 0 0];% x^4 + x + 1
            [infobits rows]=vraag2_1.genereerInformatieBits(k);
            [codewoorden rows]=vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            dist=vraag2_1.minimaleHammingAfstand(codewoorden);
            
            n_check=n;
            k_check=n-k;
            check_generator=[1 1 1 1 0 1 0 1 1 0 0 1 0 0 0];% x^11 + x^8 + x^7 + x^5 + x^3 + x^2 + x + 1
            %[check_codewoorden rows]=vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            
            generatormatrix=vraag2_1.genereerGeneratorMatrix(n, k, generator);
            syst_generatormatrix=vraag2_1.genereerSystGeneratorMatrix(n, k, codewoorden);
            
            checkmatrix=vraag2_1.genereerGeneratorMatrix(n, k, check_generator);
            syst_checkmatrix=vraag2_1.genereerSystCheckMatrix(n, k, syst_generatormatrix);
            
            dlmwrite('vraag2_1/generatormatrix.csv', generatormatrix);
            dlmwrite('vraag2_1/syst_generatormatrix.csv', syst_generatormatrix);
            dlmwrite('vraag2_1/checkmatrix.csv', checkmatrix);
            dlmwrite('vraag2_1/syst_checkmatrix.csv', syst_checkmatrix);
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
        
        function [generatorMatrix] = genereerGeneratorMatrix(n, k, generator)
            generatorMatrix=zeros(k, n);
            for i=1:k
                %generatorMatrix(i,i:(k+i-1))=generator(1,1:k);
                generatorMatrix(i,i:(n-k+i))=generator(1,1:n-k+1); % is dit correct? er wordt gewoon een stuk afgekapt...
            end
        end
        
        function [generatorMatrix] = genereerSystGeneratorMatrix(n, k, codes)
            generatorMatrix=zeros(k, n);
            for i=1:k
                match=zeros(1, k);
                match(1, i)=1;
                %res=ismember(codes(:,n-k+1:n),match,'rows');
                res=ismember(codes(:,1:k),match,'rows'); % de eenheidsmatrix moet eerst komen
                idx=find(res==1);
                generatorMatrix(i,:)=codes(idx, :);
            end
        end
        
        function [checkMatrix] = genereerSystCheckMatrix(n, k, syst_generatormatrix)
            checkMatrix=zeros(n-k, n);
            transposed=syst_generatormatrix(:, k+1:n)';
            %checkMatrix(:,1:n-k)=eye(n-k);
            %checkMatrix(:, n-k+1:n)=transposed;
            % de eenheidsmatrix moet achteraan komen
            checkMatrix(:,k+1:n)=eye(n-k);
            checkMatrix(:, 1:k)=transposed;
        end
    end
end