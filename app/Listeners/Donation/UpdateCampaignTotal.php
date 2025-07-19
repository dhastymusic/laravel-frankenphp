<?php

namespace App\Listeners\Donation;

use App\Events\DonationCompleted;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;

class UpdateCampaignTotal
{
    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(DonationCompleted $event): void
    {
        //
    }
}
