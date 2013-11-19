function compute_orientation_field( image_location, gradientSigma, blockSigma )
    if( nargin == 1 )
        gradientSigma = 1;
        blockSigma = 3;
    elseif( nargin == 2 )
        blockSigma = 3;
    end
    img = imread( image_location ); % import the path to an image type

    %% Compute the orientation field (ofield)
    
    % Calculate image gradients.
    sze = fix(6*gradientSigma);   
    if ~mod(sze,2); sze = sze+1; end
    f = fspecial('gaussian', sze, gradientSigma); % Generate Gaussian filter.
    [fx,fy] = gradient(f);                        % Gradient of Gausian.
    
    % X and Y gradients for the image
    Gx = filter2(fx, img);
    Gy = filter2(fy, img);
    
    % Estimate the local ridge orientation at each point by finding the
    % principal axis of variation in the image gradients.
   
    Gxx = Gx.^2;       % Covariance data for the image gradients
    Gxy = Gx.*Gy;
    Gyy = Gy.^2;
    
    % Now smooth the covariance data to perform a weighted summation of the
    % data.
    sze = fix(6*blockSigma);   if ~mod(sze,2); sze = sze+1; end    
    f = fspecial('gaussian', sze, blockSigma);
    Gxx = filter2(f, Gxx); 
    Gxy = 2*filter2(f, Gxy);
    Gyy = filter2(f, Gyy);
    
    % Analytic solution of principal direction
    denom = sqrt(Gxy.^2 + (Gxx - Gyy).^2) + eps;
    sin2theta = Gxy./denom;            % Sine and cosine of doubled angles
    cos2theta = (Gxx-Gyy)./denom;
    
    ofield = pi/2 + atan2(sin2theta,cos2theta)/2;

    drawOrientation(edge(img),ofield);




end