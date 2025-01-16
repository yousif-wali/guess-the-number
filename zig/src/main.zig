const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    const allocator = std.heap.c_allocator;

    // Print the initial message
    try stdout.print("Guess the number!\n", .{});

    // Initialize the random number generator
    var rng = std.rand.DefaultPrng.init(@intCast(std.time.milliTimestamp()));
    const secret_number = rng.next() % 100 + 1; // Generate number between 1 and 100

    while (true) {
        try stdout.print("Please input your guess: ", .{});

        // Read user input
        const input = try stdin.readUntilDelimiterAlloc(allocator, '\n', 256);
        defer allocator.free(input);

        // Parse the input to an integer
        const guess = std.fmt.parseInt(u64, input, 10) catch {
            _ = try stdout.print("Please enter a valid number.\n", .{});
            continue;
        };

        try stdout.print("You guessed: {d}\n", .{guess});

        // Compare the guess with the secret number
        if (guess < secret_number) {
            try stdout.print("Too small!\n", .{});
        } else if (guess > secret_number) {
            try stdout.print("Too big!\n", .{});
        } else {
            try stdout.print("You win!\n", .{});
            break;
        }
    }
}
