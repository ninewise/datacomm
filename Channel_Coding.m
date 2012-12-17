classdef Channel_Coding
          
   methods(Static=true)
        
        % Functies voor Hamming codering
        function bitenc = Ham_encode(bitstring)
            % Functie die een bitstring encodeerd met de (11,15) Hamming code.
            % input:
            % bitstring: vector van ongecodeerde bits met lengte 1xN
            
            bitstring = bitstring(:)';  % zorg ervoor dat de input een rijvector is
            N = length(bitstring);
            N_codewords = ceil(N/11);            
            
            % voeg nullen aan de bitstring toe indien N niet deelbaar is
            % door een geheel aantal codewoorden
            bitstring = [bitstring zeros(1, N_codewords*11-N)];

% Enver: dit werkte voor mij, geen tijd om de nieuwe code te testen
% (must get sleep -_-)
%             generator_matrix = [
%                 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 ;
%                 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 ;
%                 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 ;
%                 0 0 0 1 0 0 0 0 0 0 0 1 1 0 1 ; 
%                 0 0 0 0 1 0 0 0 0 0 0 1 0 1 0 ;
%                 0 0 0 0 0 1 0 0 0 0 0 0 1 0 1 ;
%                 0 0 0 0 0 0 1 0 0 0 0 1 1 1 0 ;
%                 0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 ; 
%                 0 0 0 0 0 0 0 0 1 0 0 1 1 1 1 ;
%                 0 0 0 0 0 0 0 0 0 1 0 1 0 1 1 ;
%                 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 ;   
%             ];
%        
%             % Plaats de verschillende informatiewoorden op verschillende
%             % rijen
%             info_words = reshape(bitstring, [], N_codewords)';
%             
%             % Vervang elke rij (elk informatiewoord)
%             % door zijn codewoord
%             for i = 1:N_codewords
%                 bitenc(i,:) = info_words(i,:) * generator_matrix;
%             end
%
%             % zet alles terug op 1 rij
%             bitenc = reshape(bitenc', 1, [])

            % De bitstring in informatiewoorden splitsen. Nu is elke rij van de
            % matrix bitmatrix een informatiewoord, en kunnen we de
            % oorspronkelijke string lezen volgens de normale leesrichting.
            bitmatrix = vec2mat(bitstring, 11);

            % Door de (N_codewords x 11) bitmatrix te vermenigvuldigen met de
            % (11 x 15) generatormatrix, bekomen we een gelijkvormige matrix,
            % maar dan nu met codewoorden.
            persistent n k generator infobits codewoorden;
            if isempty(n)
                n = 15; k = 11; generator = [1 1 0 0 1 0 0 0 0 0 0 0 0 0 0];
                [infobits, ~]=vraag2_1.genereerInformatieBits(k);
                [codewoorden, ~] = vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            end
            x = cellfun(@(i){codewoorden(ismember(infobits, i', 'rows'),:)}, num2cell(bitmatrix', 1));
            matrixenc = cell2mat(x);
                       
            % Nu moeten we gewoon nog de matrix matrixend lezen, en we bekomen
            % onze bitenc.
            bitenc = matrixenc';
            bitenc = bitenc(:)';
            % output: de geencodeerde bits: lengte 15*N_codewords
            % example: bitenc = zeros(1, 15*N_codewords);
        end
        
        function bitdec = Ham_decode_internal(bitenc, syst_checkmatrix, infobits, codewoorden, cleaders, s)
            bitenc = bitenc(:)';    % zorg ervoor dat de input een rijvector is
            N = length(bitenc);
            N_codewords = N/15;
            
            if(mod(N, 15) ~= 0)
                error('input is geen geheel aantal codewoorden.');
            end
            
            % We splitsen de vector bitenc op in codewoorden.
            matrixenc = vec2mat(bitenc, 15);

            % Door de matrixenc te vermenigvuldigen met de checkmatrix, bekomen
            % we een matrix van syndromen.
            syndromes = mod(matrixenc * transpose(syst_checkmatrix), 2);

            % Nu zoeken we elk syndroom op in de coset_leaders matrix.
            x = cellfun(@(i){cleaders(ismember(s, i', 'rows'),:)}, num2cell(syndromes', 1));
            transmission_errors = cell2mat(x');
            
            % Nu kunnen we de bedoelde codewoorden bepalen.
            codewords = mod(matrixenc - transmission_errors, 2);
            
            % Dan rest ons slechts het omzetten van die codewoorden in hun
            % informatiewoorden:
            y = cellfun(@(i){infobits(ismember(codewoorden, i', 'rows'),:)}, num2cell(codewords', 1));
            bitdec = cell2mat(y);
        end

        function bitdec = Ham_decode(bitenc)
            % Functie die een Hammingcode decodeerd (foutcorrectie)
            % input:
            % bitenc: vector met gecodeerde bits: lengte moet deelbaar zijn door 15
            n = 15;
            k=11;
            generator=[1 1 0 0 1 0 0 0 0 0 0 0 0 0 0];% x^4 + x + 1
            [infobits, ~]=vraag2_1.genereerInformatieBits(k);
            [codewoorden, ~] = vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            syst_generatormatrix = vraag2_1.genereerSystGeneratorMatrix(15, 11, codewoorden);
            syst_checkmatrix=vraag2_1.genereerSystCheckMatrix(n, k, syst_generatormatrix);
            [s, cleaders] = vraag2_2.genereerSyndroomTabelImproved(n, syst_checkmatrix);          

            bitdec = Channel_Coding.Ham_decode_internal(bitenc, syst_checkmatrix, infobits, codewoorden, cleaders, s);
            % output: de gedecodderde bits: lengte 11*N_codewords
        end
        
        % Functies voor de productcode
        function bitenc = Prod_encode(bitstring)
            % Functie die een bitstring encodeerd met de productcode.
            % input:
            % bitstring: vector van ongecodeerde bits met lengte 1xN
            
            bitstring = bitstring(:)';  % zorg ervoor dat de input een rijvector is
            N = length(bitstring);
            N_codewords = ceil(N/11/8);   
            
            % voeg nullen aan de bitstring toe indien N niet deelbaar is
            % door een geheel aantal codewoorden
            bitstring = [bitstring zeros(1, N_codewords*11*8-N)];

            % Product code hier
            
            % 1. Encodeer met Hamming code
            
            % Bereken de hamming codes voor alle 8 groepen van codewoorden
            ham_codes = Channel_Coding.Ham_encode(bitstring(:));
            
            % Herschaal zodat we telkens groepen van 8 codewoorden op 1
            % rij in de matrix hebben staan
            ham_codes = reshape(ham_codes, [], N_codewords)';
           
            % 2. Voeg pariteitsbits toe aan de output
            
            % Tel telkens de elementen in dezelfde "kolom" op
            % om zo de pariteitsbits te bekomen voor elk geencodeerd
            % codewoord. \Ruben: volgens mij kan dit veel sneller met wat
            % matrices magic, en ik zou die initialisatie op zeros zeker
            % gebruiken, anders zal hij telkens bij het loopen de grootte
            % van de matrix moeten veranderen, wat dus redelijk duur is...
            % par_bits = zeros(N_codewords*8, 15);
            %size(ham_codes)
            for i = 1:N_codewords
                for j = 1:15
                    par_bits(i,j) = sum( ham_codes(i, j:15:(8*15)) );
                end
            end
            
            bitenc = horzcat(ham_codes, par_bits);
            
            % output:
            % bitenc = zeros(1, (8+1)*15*N_codewords);
            
            % zet alles terug op 1 rij

            bitenc = mod(reshape(bitenc', 1, []), 2);
            
        end
        
        function bitdec = Prod_decode(bitenc)
            % Functie die een productcode decodeerd (foutcorrectie)
            % input:
            % bitenc: vector met gecodeerde bits: lengte moet deelbaar zijn door 15
            
            % bepaal de checkmatrix en syndroomtabel

            n=15;
            k=11;
            l=8;
            generator=[1 1 0 0 1 0 0 0 0 0 0 0 0 0 0];% x^4 + x + 1
            [infobits, ~]=vraag2_1.genereerInformatieBits(k);
            [codewoorden, ~] = vraag2_1.genereerCodeWoorden(n, k, infobits, generator);
            syst_generatormatrix = vraag2_1.genereerSystGeneratorMatrix(n, k, codewoorden);
            syst_checkmatrix=vraag2_1.genereerSystCheckMatrix(n, k, syst_generatormatrix);
            [syndroomtabel, cosetleiders]=vraag2_2.genereerSyndroomTabelImproved(n, syst_checkmatrix);
            
            % essentiële berekeningen en checks
            bitenc = bitenc(:)';    % zorg ervoor dat de input een rijvector is
            N = length(bitenc);
            N_codewords = N/15/(8+1);
            blok_lengte=15*(8+1);
            dec_blok_lengte=15*8;
            def_dec_blok_lengte=11*8;
            if(mod(N, blok_lengte) ~= 0)
                error('input is geen geheel aantal codewoorden.');
            end
            
            % initialiseer de (gedeeltelijk) gedecodeerde bits
            bit_pdec=zeros(1, N_codewords*dec_blok_lengte);
            
            % initialiseer de gedecodeerde bits
            bitdec = zeros(1, def_dec_blok_lengte*N_codewords);
            
            % --- errorcorrectie hier ----
            
            % overloop alle blokken
            for blok = 1:N_codewords
                % stel dit blok op
                this_bitenc=bitenc(1, (blok-1)*blok_lengte+1:blok*blok_lengte);
                
                % maak een lege cellarray voor de verkeerde syndromen (voor
                % in de errorcorrectie)
                verkeerde_syndromen={};
                
                % splits het ontvangen codewoord om naar (l+1) rijen van n bits
                codewords=reshape(this_bitenc, n, (l+1))';
                
                % Stel handmatig een fout in (TMP!)
                % codewords(1, 8)=mod(codewords(1, 8)+1,2);
                % codewords(1, 9)=mod(codewords(1, 9)+1,2);
                % codewords(2, 8)=mod(codewords(2, 8)+1,2);

                % bereken pariteiten
                berekende_pariteiten=mod(sum(codewords), 2);

                % verwijder pariteiten van het codewoorden (deze waren
                % enkel nuttig om onze eigen pariteiten te berekenen)
                codewords=codewords(1:l, :);
                
                % bereken syndromen voor alle rijen
                syndromen=mod(codewords * syst_checkmatrix', 2);
                
                % zoek alle fouten
                fouten=find(any(syndromen, 2));

                % overloop alle rijen met fouten
                for j = 1:size(fouten)
                    % bepaal de plaats van het bepaalde syndroom in de
                    % vooraf opgestelde syndroomtabel
                    [~,index_gevonden_syndroom]=ismember(syndromen(fouten(j),:),syndroomtabel,'rows');
                    % bepaal de foutpositie adhv de cosetleiders
                    foutpositie=find(cosetleiders(index_gevonden_syndroom, :));

                    % kijk als de pariteitsbit op de foutpositie gelijk is aan 1
                    if berekende_pariteiten(foutpositie) == 1 % aantal fouten == 1, anders meerdere fouten
                        % we kunnen perfect de fout herstellen :D
                        codewords(fouten(j), foutpositie)=mod(codewords(fouten(j), foutpositie)+1,2);
                        berekende_pariteiten(foutpositie)=0;
                        %'een fout hersteld'
                    else
                        verkeerde_syndromen{end+1}={syndromen(fouten(j),:),fouten(j)};
                    end
                end
                
                % als verkeerde_syndromen > 2 of == 0, doe niets, anders wel
                if size(verkeerde_syndromen, 2) == 1 % er komen 2 fouten voor in deze rij
                    % zoek de (berekende) pariteitsbits verschillend van 0
                    fouten=find(berekende_pariteiten);
                    % flip de overeenkomstige bits in de beschouwe rij en 
                    % fix de pariteiten
                    beschouwde_rij=verkeerde_syndromen{1}{2};
                    if(numel(fouten) > 0)
                        for j = 1:size(fouten)
                            codewords(beschouwde_rij, fouten(j))=mod(codewords(beschouwde_rij, fouten(j))+1,2);
                            berekende_pariteiten(fouten(j))=0;
                        end
                    end
                    %'één fout hersteld'
                elseif size(verkeerde_syndromen, 2) == 2 & verkeerde_syndromen{1}{1}==verkeerde_syndromen{2}{1}% && GELIJKE SYNDROMEN! er treden 2 fouten op in één kolom 
                    % bepaal de plaats van het bepaalde syndroom in de
                    % vooraf opgestelde syndroomtabel, we moeten maar één
                    % van de twee syndromen bekijken omdat deze toch gelijk
                    % zijn.
                    [~,index_gevonden_syndroom]=ismember(verkeerde_syndromen{1}{1},syndroomtabel,'rows');
                    % bepaal de foutpositie adhv de cosetleiders
                    foutpositie=find(cosetleiders(index_gevonden_syndroom, :));
                    % herstel de twee rijen
                    rij1=verkeerde_syndromen{1}{2};
                    rij2=verkeerde_syndromen{2}{2};
                    codewords(rij1, foutpositie)=mod(codewords(rij1, foutpositie)+1,2);
                    codewords(rij2, foutpositie)=mod(codewords(rij2, foutpositie)+1,2);
                    %'twee fouten hersteld'
                end
                
                % vorm het codewoord weer om naar 1 rij van n*l bits (niet
                % meer l+1, want de pariteitsbits zijn nu weg!)
                codewords=reshape(codewords', 1, n*l)';
                
                % sla dit blok op de juiste plaats in bitenc
                bit_pdec(1, (blok-1)*dec_blok_lengte+1:blok*dec_blok_lengte)=codewords;
                
                % decodeer met hamming
                for i=1:l
                    dec_start=(blok-1)*def_dec_blok_lengte+(i-1)*k+1;
                    dec_endd=(blok-1)*def_dec_blok_lengte+i*k;
                    p_start=(blok-1)*dec_blok_lengte+(i-1)*n+1;
                    p_endd=(blok-1)*dec_blok_lengte+i*n;
                    %bit_pdec(p_start:p_endd)
                    bitdec(dec_start:dec_endd)=Channel_Coding.Ham_decode_internal(bit_pdec(p_start:p_endd), syst_checkmatrix, infobits, codewoorden, cosetleiders, syndroomtabel);
                end
            end
        end
    end
    
end
