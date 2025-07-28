{{ metrics.calculate(
    metric('total_oil'),
    grain='day',
    group_by=['region', 'field']
) }}