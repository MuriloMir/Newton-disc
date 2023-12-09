// This software will draw a Newton disc and make it spin until it all turns white.

import arsd.simpledisplay : Color, Point, ScreenPainter, SimpleWindow;
import std.math : cos, round, sin;

void main()
{
    // create the window for the GUI
    SimpleWindow window = new SimpleWindow(800, 800, "Disco de Newton");
    // create the 7 colors of the rainbow
    Color[7] colors = [Color(254, 0, 0), Color(255, 127, 0), Color(255, 255, 0), Color(0, 128, 1), Color(0, 0, 254), Color(75, 0, 129),
                       Color(148, 0, 212)];
    // 'counter' will count how many times it has spun, 'startX' and 'startY' will be used to calculate the coordinates of the next points
    int counter, startX, startY = 300;
    // 'angle' will be the angle in radians that it must spin and 'speed' will tell how fast it has to spin
    float angle, speed = 0.0;
    // 'origin' will be the center of the screen, 'previous' and 'next' will keep track of the previous point and the next point to draw a line
    Point origin = Point(400, 400), previous, next;

    // clear the window, it's in a scope so the GUI gets flushed right away
    {window.draw().clear(Color.black());}

    // start the event loop
    window.eventLoop(2,
    {
        // create the painter
        ScreenPainter painter = window.draw();

        // use a loop to draw each color
        foreach (i; 0 .. 7)
        {
            // select a color
            painter.outlineColor = colors[i];

            // use a loop to draw each line of the current color, many consecutive lines will form a section of the disc
            foreach (j; 0 .. 410)
            {
                // calculate the angle it will use to rotate the points
                angle = 51.43 * i * (3.14159 / 180.0) + j * (3.14159 / 1440.0) + speed;
                // calculate the next point where it will draw
                next = Point(400 + cast(int) round(startX * cos(angle) + startY * sin(angle)), 400 - cast(int) round(startX * -sin(angle) + startY * cos(angle)));

                // if the next point is different from the previous (there is no need to draw it again when they are equal)
                if (next != previous)
                {
                    // draw the line
                    painter.drawLine(origin, next);
                    // update the previous point
                    previous = next;
                }
            }
        }

        // if less than 2 seconds have passed (2msec * 1000)
        if (counter < 1000)
           // increase the rotation speed
           speed += 0.02;
        // if less than 4 seconds have passed (2msec * 2000)
        else if (counter < 2000)
           // increase the rotation speed
           speed += 0.1;
        // if more than 4 seconds have passed
        else
           // increase the rotation speed
           speed += 0.3;

        // make sure the speed is not greater than 2 * pi (which is a full circle)
        speed %= 3.14159 * 2.0;

        // if less than 4 seconds have passed (2msec * 2000)
        if (counter < 2000)
           // increment the counter, we don't need to increment it after 4 seconds because the speed will not change after that
           counter++;
    });
}
