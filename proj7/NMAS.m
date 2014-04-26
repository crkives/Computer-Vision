function interestPoints = NMAS( N, R, octave )

    %N = 6;
    %threshold = -2.0;
    patchSize = uint8( 40 / 2^octave );
    %[ row, col, val ] = find( R.*(R > threshold) );
    
    
    % Remove interest points that are within patch size of the image edge
    halfPatch = ceil( (1/2)*patchSize );
    
    topStartRow = 1;
    topEndRow = halfPatch + 1;
    bottomStartRow = size( R, 1 ) - halfPatch - 1;
    bottomEndRow = size( R, 1 );
        
    frontStartCol = 1;
    frontEndCol = halfPatch + 1;
    backStartCol =size( R, 2 ) - halfPatch - 1;
    backEndCol = size( R, 2 );
    
    R(topStartRow:topEndRow, : ) = -10000;
    R(bottomStartRow:bottomEndRow, : ) = -10000;
    
    R(:, frontStartCol:frontEndCol) = -10000;
    R(:, backStartCol:backEndCol) = -10000;
    
    sortedValues = sort( R(:) );
    %dah= 'Data from NMAS'
    %octave
    %size( R )
    %size( sortedValues )
    maxValues = sortedValues( end-500:end );
    maxIndex = ismember( R, maxValues );
    index = find( maxIndex );
    [x y] = ind2sub( size(R), index );
    idx = sub2ind( [size(R, 1) size(R, 2) ], y, x );
    v = R( idx );
    
    %dah = 'newRow and newCol'
    newRow = y;
    %size(newRow)
    newCol = x;
    %size(newCol)
    newVal = v;
    
    
   % if( mod( patchSize, 2 ) == 0 )
   %     endRowVec = endRowVec - 1;
   %     endColVec = endColVec - 1;
   % end
    
   % goodPoints = ( startRowVec >= 1 & endRowVec <= size( R, 1 ) & startColVec >= 1 & endColVec <= size( R, 2 ) );
   % newRow = row( goodPoints == 1 );
   % newCol = col( goodPoints == 1 );
   % newVal = val( goodPoints == 1 );


    [ sortedVal, sortedIndecies ] = sort( newVal, 'descend' );
    sortedRow = newRow( sortedIndecies );
    sortedCol = newCol( sortedIndecies );

    pointsMatrix = [ sortedCol, sortedRow  ];
    distVector = pdist( pointsMatrix );
    distMatrix = squareform( distVector );

    pointRadii = zeros( size( newRow, 1 ), 1 );
    pointRadii( 1, 1 ) = size( R, 1 );
    %dah = 'pointRadii size'
    %size( pointRadii )

    for i = 2: size( newRow, 1 )
        %dah = 'current i'
        %i
        rowVecDist = distMatrix( i, : );
        %dah = 'rowVecDist size'
        %size( rowVecDist )
        strength = sortedVal( i );
        %dah = 'Strength'
        %strength
        upperIndex = find( sortedVal > strength, 1, 'last' );
        %dah = 'upper index'
        %upperIndex
        potentialVec = rowVecDist( 1:upperIndex );
        %dah = 'potentialVec size'
        %size( potentialVec )
        %potentialVec
        radius = min( potentialVec );
        %dah = 'current radius'
        %radius
        pointRadii( i, 1 ) = radius;
    
    end

    [ sortedRadii, sortedRadiiIndicies ] = sort( pointRadii, 'descend' );
    finalRow = sortedRow( sortedRadiiIndicies );
    finalCol = sortedCol( sortedRadiiIndicies );
    finalVal = sortedVal( sortedRadiiIndicies );

    %interestPoints = [ finalRow( 1:N, 1 ), finalCol( 1:N, 1 ), sortedRadii( 1:N, 1 ) , finalVal(1:N)];
    interestPoints = [ finalRow( 1:N, 1 ), finalCol( 1:N, 1 )];

end




    