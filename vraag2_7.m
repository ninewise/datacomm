
classdef vraag2_7
    
    methods(Static)
        
        function [] = main
           darth_vader = imread('darthvader.bmp', 'bmp');
           p = 0.01;
           [height, width] = size(darth_vader);
           
           % Gewoon zonder codering.
           uncoded = FakeChannel.send(p, darth_vader);
           uncoded = reshape(uncoded, height, width);
           imwrite(mod(uncoded + 1, 2), 'uncoded.bmp', 'bmp');
           
           % Met Hamming codering.
           ham_coded_src = Channel_Coding.Ham_encode(darth_vader);
           ham_coded_rec = FakeChannel.send(p, ham_coded_src);
           ham_coded = Channel_Coding.Ham_decode(ham_coded_rec);
           ham_coded = reshape(ham_coded(1:(height*width)), height, width);
           imwrite(mod(ham_coded + 1, 2), 'ham_coded.bmp', 'bmp');
           
           % Met Productcodering.
           prod_coded_src = Channel_Coding.Prod_encode(darth_vader);
           prod_coded_rec = FakeChannel.send(p, prod_coded_src);
           prod_coded = Channel_Coding.Prod_decode(prod_coded_rec);
           prod_coded = reshape(prod_coded(1:(height*width)), height, width);
           imwrite(mod(prod_coded + 1, 2), 'prod_coded.bmp', 'bmp');

           % Wat betreft de vreemde inversies net voor het wegschrijven
           % van de afbeelding: Bekijk het resultaat van onderstaande
           % code, waarvan je zou verwachten dat ze de afbeelding
           % kopieert.
           %
           %    image = imread('darthvader.bmp', 'bmp');
           %    imwrite(image, 'darthvader_copy.bmp', 'bmp');
           %
        end
        
    end
    
end
