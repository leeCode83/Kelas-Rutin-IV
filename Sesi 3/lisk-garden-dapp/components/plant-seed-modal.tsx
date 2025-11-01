"use client"

import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Sparkles, Coins } from "lucide-react"
import { usePlants } from "@/hooks/usePlants"
import { PLANT_PRICE } from "@/types/contracts"

interface PlantSeedModalProps {
    isOpen: boolean
    onClose: () => void
}

export default function PlantSeedModal({ isOpen, onClose }: PlantSeedModalProps) {
    const { plantSeed, loading } = usePlants()

    const handlePlant = async () => {
        await plantSeed()
        onClose()
    }

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="max-w-md">
                <DialogHeader>
                    <DialogTitle className="flex items-center gap-2">
                        <Sparkles className="w-5 h-5 text-accent" />
                        Plant a New Seed
                    </DialogTitle>
                    <DialogDescription>Plant a seed and watch it grow!</DialogDescription>
                </DialogHeader>

                <div className="space-y-4">
                    {/* Seed card */}
                    <Card className="p-6 border-2 border-primary/30 bg-gradient-to-br from-primary/5 to-accent/5">
                        <div className="text-center">
                            <div className="text-6xl mb-4">🌱</div>
                            <h3 className="font-bold text-xl text-foreground mb-2">Garden Seed</h3>
                            <p className="text-sm text-muted-foreground mb-4">
                                A magical seed that grows through 4 stages over time
                            </p>

                            {/* Growth stages preview */}
                            <div className="flex justify-center gap-2 mb-4">
                                <span className="text-2xl" title="Seed">🌱</span>
                                <span className="text-xl text-muted-foreground">→</span>
                                <span className="text-2xl" title="Sprout">🌿</span>
                                <span className="text-xl text-muted-foreground">→</span>
                                <span className="text-2xl" title="Growing">🪴</span>
                                <span className="text-xl text-muted-foreground">→</span>
                                <span className="text-2xl" title="Blooming">🌸</span>
                            </div>

                            {/* Price */}
                            <div className="bg-card border border-border rounded-lg p-3">
                                <p className="text-xs text-muted-foreground mb-1">Cost</p>
                                <p className="flex items-center justify-center gap-2 font-bold text-lg text-accent">
                                    <Coins className="w-5 h-5" />
                                    {PLANT_PRICE} ETH
                                </p>
                                <p className="text-xs text-muted-foreground mt-1">
                                    Harvest reward: 0.003 ETH (3x profit!)
                                </p>
                            </div>
                        </div>
                    </Card>

                    {/* Info card */}
                    <Card className="p-3 bg-muted/30 border-primary/20">
                        <p className="text-xs text-muted-foreground">
                            💧 <strong>Watering is FREE</strong> - no cost, just gas!
                            <br />
                            ⏱️ <strong>Growth time</strong>: 3 minutes from seed to blooming
                            <br />
                            💰 <strong>Profit</strong>: Earn 3x your investment when you harvest
                            <br />
                            ⚠️ <strong>Keep watering</strong>: Plant dies if water reaches 0%
                        </p>
                    </Card>

                    {/* Action buttons */}
                    <div className="flex gap-2 pt-2">
                        <Button
                            variant="outline"
                            onClick={onClose}
                            className="flex-1 bg-transparent"
                            disabled={loading}
                        >
                            Cancel
                        </Button>
                        <Button
                            onClick={handlePlant}
                            disabled={loading}
                            className="flex-1 gap-2 bg-primary hover:bg-primary/90"
                        >
                            {loading ? (
                                <>
                                    <div className="w-4 h-4 border-2 border-primary-foreground border-t-transparent rounded-full animate-spin" />
                                    Planting...
                                </>
                            ) : (
                                <>
                                    <Sparkles className="w-4 h-4" />
                                    Plant Seed
                                </>
                            )}
                        </Button>
                    </div>
                </div>
            </DialogContent>
        </Dialog>
    )
}