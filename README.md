
### Summary: Include screen shots or a video of your app highlighting its features

Overall usage (search, filter, reload): https://drive.google.com/file/d/1gagl34QzSUBp960CknBA9WK8V-IVtIJw/view?usp=sharing
Image caching (notice the images loading after cache is cleared): https://drive.google.com/file/d/1WooAokqFi8vLMLbx-QjyKwAA-4lX-9NR/view?usp=sharing
Tapping source URL: https://drive.google.com/file/d/1OwdCOToDCa4VbTXk4_B64ywD8ZPNMwZd/view?usp=sharing

Missing key error: https://drive.google.com/file/d/1OtPiJkDh-7AxPI0U3Xqx_ho_P7y24EUU/view?usp=sharing
Empty list: https://drive.google.com/file/d/1xGjhj45gObrAx1kiQBKewyMxIHc0bDva/view?usp=sharing

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

Every major feature on the app took equal priority. Originally, the minimum required features for this project (fetching/displaying data, caching images, etc.) was the main focus, but these were completed quickly. So additional features and UI enhancements were all given equal attention.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I spent roughly 7 hours on this project. I received the instructions Tuesday, and I spent the rest of the weekdays experimenting with design in my free time, totalling 1-2 hours. On the weekends, I spent ~5 hours on the app. As mentioned before, the basic requirements were quickly met, so most of my time was spent coding additional features. Unit testing was done afterwards, as the additional features inspired more meaningful tests.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

As far as requirements are concerned, there was only one major tradeoff: I used async/await to fetch the JSON data, but not the images. Async/await works best with URLSession which has a built-in caching mechanism by default. To avoid using that, I fetched data the "old" way which isn't immediately compatible with async/await. On the surface, the app still runs efficiently and as expected.

Another tradeoff/decision was to not cache large images, as they are fetched less frequently (than small images) and take up more space.
All other tradeoffs were simple design decisions. For example, my original idea was to have the additional recipe details drop down from under the listing, but I chose to use sheets instead for their versatility.

### Weakest Part of the Project: What do you think is the weakest part of your project?

The weakest part of my project is the unit testing. My existing tests are functional and intuitive, but I struggled to come up with as many tests as I'd like. Since there are very few computational operations, it's not immediately obvious what to test.

