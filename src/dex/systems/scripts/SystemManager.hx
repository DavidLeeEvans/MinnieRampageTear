package dex.systems.scripts;

import defold.support.Script;


typedef SystemManagerProperties =
{
    /**
     * The `Metrics` peak counters will be reset once every
     * this interval (in seconds).
     */
    @property(10) var resetMetricsPeaksEvery: Float;
}

class SystemManager<T: SystemManagerProperties> extends Script<T>
{
    override function init(self: T)
    {
        Time.init();
        Metrics.init();
        Postman.init();
    }

    override function update(self: T, dt: Float)
    {
        Time.update(dt);
        if (Time.every(self.resetMetricsPeaksEvery))
        {
            Metrics.resetPeakCounters();
        }

        Metrics.update();
        Postman.update();
    }

    override function final_(self: T)
    {
    }
}
