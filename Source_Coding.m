classdef Source_Coding
          
    methods(Static=true)
        
        % Functies voor de Huffmancode op te stellen
        function codewords = create_codebook(alphabet, rel_freq)
            % Functie die de Huffmancode opstelt voor gegeven alfabet en
            % relative frequenties
            % input:
            % alphabet: 1xN cell array vb alphabet = {'A', 'B', 'C', 'D'}
            % rel_freq: relative frequenties voor elke letter in het
            % alfabet: 1xN vector vb: rel_freq = [0.5 0.1 0.3 0.1];
            
            N = numel(alphabet);
            rel_freq = rel_freq/sum(rel_freq);
            
            %% A. Declareren en initialiseren van enkele variabelen
            % Cell array die alle indices van elk teken in het alphabet bijhoudt
            % in apparte cell arrays
            alphabet_indices = cell(1, N);

            for i = 1:N
                alphabet_indices{i} = {i};
            end

            % Cell array die de voorlopige codes voor elke teken bijhoudt
            codes = cell(1,N);

            %% B. Vormen van de Huffman codes

            % Loop zolang er meer dan 1 elementen in alphabet_indices zit 
            % (dus zolang we niet aan de "top van de boom" zitten
            while (length(alphabet_indices) > 1)
                %% 1. Sorteer freq. en de de overeenkomstige indices in alphabet_indices
                [rel_freq_sorted, sorted_indices] = sort(rel_freq);

                rel_freq = rel_freq_sorted;
                alphabet_indices = alphabet_indices(sorted_indices);

                %% 2. Ken codes toe aan de 2 symbolen met de kleinste frequenties
                for i = 1:length(alphabet_indices{1})
                    indices = alphabet_indices{1}{i};

                    for j = indices
                        codes(j) = {[0 codes{j}]};
                    end
                end

                for i = 1:length(alphabet_indices{2})
                    indices = alphabet_indices{2}{i};

                    for j = indices
                        codes(j) = {[1 codes{j}]};
                    end
                end

                %% 3. Groepeer de 2 kleinste symbolen samen en tel hun freqs op
                rel_freq(2) = rel_freq(1) + rel_freq(2);
                rel_freq(1) = [];

                alphabet_indices{2} = [alphabet_indices{1} alphabet_indices{2}];
                alphabet_indices(1) = [];
            end
            
            %output the codewords
            % example: codewords = {[0], [1 1 0], [1 0], [1 1 1]};
            codewords = codes;
            
        end

        function codewords = create_canonical_codebook(alphabet, lengths)
            % Functie die de Canonical Huffmancode opstelt voor gegeven alfabet en
            % codelengtes
            % input:
            % alphabet: 1xN cell array vb alphabet = {'A', 'B', 'C', 'D'}
            % lengths: lengtes van elk codewoord: [1 3 2 3];
            
            N = numel(alphabet);
      
            sortedlengths = sort(lengths);                           
            % Maak canonical huffmancode
            sortedcodewords = cell(1,N);
            sortedcodewords(1,1) = {[0]};
            curlength = 1;
                        
            for i = 2:N
                % Zet binaire cellarray om naar nummer en tel er 1 bij op
                array = sortedcodewords{1,i-1};
                number = bin2dec(sprintf('%-1d',array)) + 1;
                
                % Wordt het aantal codebits groter?
                if (curlength < sortedlengths(i))
                    % Voeg 0 toe tot juiste aantal codebits bereikt is
                    number = bitsll(number,sortedlengths(i)-curlength);
                    curlength = sortedlengths(i);
                end
                % Converteer decimaal terug naar een binaire cellarray
                sortedcodewords(1,i) = {de2bi(number, 'left-msb')};
            end
            
            
            % output the codewords
            % example: codewords = {[0], [1 1 0], [1 0], [1 1 1]};
            codewords = cell(1, N);
            for i = 1:N
                for j = 1:N
                   if(lengths(j) == sortedlengths(i))
                       codewords(1,i) = sortedcodewords(1,j);
                       % Truc om deze waarde in het vervolg over te slaan
                       lengths(j) = -1;
                       break
                   end
                end
            end
        end
      
        
        % Functies voor het encoderen/decoderen
        function compressed = Huffman_encode(data, alphabet, codewords)
            % Functie die een bitstring comprimeerd met een Huffmancode
            % input:
            % data: de data die gecomprimeerd moet worden
            % alphabet: cell array of rijvector met alle mogelijke symbolen 
            % codewords: cell array met de codewoorden voor elke letter in
            % het alfabet.
            
            N = length(data);
            N_symbols = length(alphabet);            
            
            if iscell(alphabet) && max(cellfun(@length, alphabet))>1
                error('ERROR: een symbool uit het alfabet mag maar 1 cijfer of alfanumerieke waarde bevatten');
            end
            
            if ischar(data)                
                % converteer de alfanumerieke waardes naar numeriek waardes
                numeric_data = double(data);
                numeric_symbols =  cellfun(@double, alphabet);                             
            elseif isrow(data)
                numeric_data = data;
                if iscell(alphabet),    numeric_symbols = cell2mat(alphabet);     
                else numeric_symbols = alphabet;     
                end
            else
                error('ERROR: input moet ofwel een rijvector of een karakater-string zijn');
            end    
             
            % De kern van deze functie: vervang elke letter uit het alfabet 
            % met het corresponderend codewoord            
            compressed = cell(1,N);
            for n=1:N_symbols
                idx = numeric_data==numeric_symbols(n);
                compressed(idx) = {codewords{n}};
            end
            
            % Als er nog lege cellen overblijven wil dit zeggen dat het
            % woordenboek niet alle mogelijke symbolen uit de data heeft.
            if nnz(cellfun(@isempty,compressed))
                error('ERROR: woordenboek incompleet');
            end
                   
            % zet om naar een rijvector
            compressed = cell2mat(compressed);            
            
        end
        
        function decompressed = Huffman_decode(data_compressed, alphabet, codebook)
            % Functie die een gecomprimeerde bitsequentie decomprimeerd
            % Optimaal werkt deze functie met een boom maar hier
            % decomprimeren we simpelweg door te itereren.
            % input
            % data_compressed
            % alphabet: cell array of rijvector met alle mogelijke symbolen 
            % codewords: cell array met de codewoorden voor elke letter in
            % het alfabet.
            
            N = length(data_compressed);
            
            % voorbereiding: splits de codewoorden op per lengte
            lengths = cellfun(@length, codebook);
            max_len = max(lengths);
                
            cl = cell(1,max_len);
            idxl = cell(1,max_len);
            for l=1:max_len
                idx_l = find(lengths==l);
                % zet de codewoorden van lengte l om naar hun decimale vorm                
                cl{l} = cellfun(@bi2de, codebook(idx_l));
                idxl{l} = idx_l;
            end                      
            
            % decompressie: doorloop de data en zoek naar codewoorden
            output = [];    % bevat de indices van de letters die herkend zijn.
            idx = 1;        % index in de data
            window = 1;     % bereik waarover we zoeken: we beginnen met zoeken naar codewoorden van lengte 1
            while idx+window <= N+1
                idx_code = find(cl{window} == bi2de(data_compressed(idx:idx+window-1)));
                if ~isempty(idx_code)    
                    %codewoord gevonden, voeg dit toe aan de output en ga verder
                    output = [output idxl{window}(idx_code)];                     
                    idx = idx + window;
                    window = 1;
                else
                    % nog geen codewoord gevonden; vergroot het bereik
                    window = window+1;
                end
            end
                      
            % zet de output om naar letters uit het alfabet
            decompressed = alphabet(output);
            
        end
        
        
    end
    
end