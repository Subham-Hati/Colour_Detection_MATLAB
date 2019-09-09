obj=videoinput('winvideo',1,'yuy2_640x360');
obj.ReturnedColorspace = 'rgb';
B=getsnapshot(obj);
 
framesAcquired = 0;
x=arduino();
 
while (framesAcquired <= 100) 
    
      data = getsnapshot(obj); 
      framesAcquired = framesAcquired + 1;    
      
      diff_imR = imsubtract(data(:,:,1), rgb2gray(data)); 
      diff_imR = medfilt2(diff_imR, [3 3]);             
      diff_imR = im2bw(diff_imR,0.18);                   
      %stats = regionprops(diff_im, 'BoundingBox', 'Centroid'); 
      
      %counting red objects
      diff_imR2=~diff_imR; %complement
      CountR = bwboundaries(diff_imR2);
      if length(CountR) > 1
         writeDigitalPin(x, 'D10', 1);
      else
         writeDigitalPin(x, 'D10', 0);
      end       
    
     
      
      diff_imG = imsubtract(data(:,:,2), rgb2gray(data)); 
      diff_imG = medfilt2(diff_imG, [3 3]);             
      diff_imG = im2bw(diff_imG,0.18);
      %counting Green objects
      diff_imG2=~diff_imG; %complement
      CountG = bwboundaries(diff_imG2);
      if length(CountG) > 1
         writeDigitalPin(x, 'D8', 1);
      else
         writeDigitalPin(x, 'D8', 0);
      end   
      
      diff_imB = imsubtract(data(:,:,3), rgb2gray(data)); 
      diff_imB = medfilt2(diff_imB, [3 3]);             
      diff_imB = im2bw(diff_imB,0.18);  
      
     %counting blue objects
      diff_imB2=~diff_imB; %complement
      CountB = bwboundaries(diff_imB2);
      if length(CountB) > 1
         writeDigitalPin(x, 'D9', 1);
      else
         writeDigitalPin(x, 'D9', 0);
      end   
      
  
      % Remove all those pixels less than 300px
      diff_imR = bwareaopen(diff_imR,300);
      diff_imG = bwareaopen(diff_imG,300);
      diff_imB = bwareaopen(diff_imB,300);
    
    % Label all the connected components in the image.
     bwR = bwlabel(diff_imR, 8);
     bwB = bwlabel(diff_imB, 8);
     bwG = bwlabel(diff_imG, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    statsR = regionprops(bwR, 'BoundingBox', 'Centroid');
    statsG = regionprops(bwG, 'BoundingBox', 'Centroid');
    statsB = regionprops(bwB, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for objectR = 1:length(statsR)
        bbR = statsR(objectR).BoundingBox;
        bcR = statsR(objectR).Centroid;
        rectangle('Position',bbR,'EdgeColor','r','LineWidth',2)
        plot(bcR(1),bcR(2), '-m+')
        a=text(bcR(1)+15,bcR(2), strcat('X: ', num2str(round(bcR(1))), '    Y: ', num2str(round(bcR(2))), '    Color: Red'));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'red');
         
    end 
    
    
    for objectG = 1:length(statsG)
        bbG = statsG(objectG).BoundingBox;
        bcG = statsG(objectG).Centroid;
        rectangle('Position',bbG,'EdgeColor','g','LineWidth',2)
        plot(bcG(1),bcG(2), '-m+')
        b=text(bcG(1)+15,bcG(2), strcat('X: ', num2str(round(bcG(1))), '    Y: ', num2str(round(bcG(2))), '    Color: Green'));
        set(b, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green');
    end  
    
          for objectB = 1:length(statsB)
        bbB = statsB(objectB).BoundingBox;
        bcB = statsB(objectB).Centroid;
        rectangle('Position',bbB,'EdgeColor','b','LineWidth',2)
        plot(bcB(1),bcB(2), '-m+')
        c=text(bcB(1)+15,bcB(2), strcat('X: ', num2str(round(bcB(1))), '    Y: ', num2str(round(bcB(2))), '    Color: Blue'));
        set(c, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'blue');
          end
    
    hold off
    
end
 
clear all
