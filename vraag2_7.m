
classdef vraag2_7
    
    methods(Static)
        
        function [] = main
           darth_vader = imread('darthvader.bmp', 'bmp');
           p = 0.01;
           [height, width] = size(darth_vader);
           
           % Gewoon zonder codering.
           uncoded = FakeChannel.send(p, darth_vader);
           uncoded = reshape(uncoded, height, width);
           sum(uncoded == darth_vader);
           imwrite(uncoded, 'uncoded.bmp', 'bmp');
           
           % Met Hamming codering.
           ham_coded_src = Channel_Coding.Ham_encode(darth_vader);
           ham_coded_rec = FakeChannel.send(p, ham_coded_src);
           ham_coded = Channel_Coding.Ham_decode(ham_coded_rec);
           ham_coded = reshape(ham_coded(1:(height*width)), height, width);
           imwrite(ham_coded, 'ham_coded.bmp', 'bmp');
           
           % Met Productcodering.
           prod_coded_src = Channel_Coding.Prod_encode(darth_vader);
           prod_coded_rec = FakeChannel.send(p, prod_coded_src);
           prod_coded = Channel_Coding.Prod_decode(prod_coded_rec);
           prod_coded = reshape(prod_coded(1:(height*width)), height, width);
           imwrite(prod_coded, 'prod_coded.bmp', 'bmp');
        end
        
    end
    
end